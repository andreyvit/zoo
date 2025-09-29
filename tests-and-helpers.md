# Questioning the abstraction level of test helpers.

A vital challenge is keeping test helpers at the right level of abstraction: not too specific and not too generic.

## Example: `saveSettingsToDatabase`

```go
// Helper: Saves settings to database
func saveSettingsToDatabase(ta *firetesting.App, settings *bm.TenantSettings) {
	ta.Helper()
	ta.Update(func() {
		edb.Put(ta.RC(), settings)
	})
}
```

Now, what do we see?

1. This is basically edb.Put inside ta.Update.
2. This is NOT specific to settings at all, it could put any row -- edb.Put accepts any, so no reason for this func to be more specific. So the name is misleading; it could be WAY more generic without changing the implementation.
3. edb.Put accepts edb.Txish which is implemented by ta, so .RC() is superflous
4. The comment adds zero value
5. This is a wrapper around Put so perhaps should be called put, not save.

Our 2nd iteration:

```go
func put(ta *firetesting.App, row any) {
	ta.Helper()
	ta.Update(func() {
		edb.Put(ta, row)
	})
}
```

This is obviously not specific to the narrow use case of our specific test. As a generic helper, we should put it somewhere generic. If this was specific to something like referrals, we'd put it in something like referralstesting. But this is a super-generic helper, and a bunch of similar ones are already in firetesting, so let's move it to firetesting.Put.

Also, given that it's a wrapper around edb.Put, let's examine edb.Put:

```go
func Put(txh Txish, rows ...any) bool { ... }
```

It seems reasonable that a wrapper around Put should retain the ability to save multiple rows:

```go
func Put(ta *firetesting.App, rows ...any) {
	ta.Helper()
	ta.Update(func() {
		edb.Put(ta, rows...)
	})
}
```

Now, we came up with the best version of this helper we could. What remains is to justify its existence in the first place. Does it improve the test code, or are we better off inlining it? Which test code do we prefer? A:

```go
ta.Update(func() {
	edb.Put(ta, row)
})
```

or B:

```go
firetesting.Put(ta, row)
```

Honestly A is not too bad, so the decision is unclear. `ta.Update(func() { ... })` adds some visual noise, and in tests, the fact that we open a write transaction might be entirely uninteresting -- there's no concurrency to worry about, and we typically can just save something without worrying about. So this helper is not harmful at least, and saves some noise. Still, it's a trivial operation that's trivial to parse inline, so we're still undecided.

Let's see how often it would be used by grepping the codebase for `ta.Update(func() { ... })` blocks with a single `edb.Put` inside. Seems like there's a number of these, so this is a moderately common operation.

Verdict: firetesting.Put can stay, and should be used where we just need to save one row to the database to make tests a little easier to read.


## Example: `loadSettingsFromDatabase`

```go
// Helper: Loads settings from database
func loadSettingsFromDatabase(ta *firetesting.App, tenantID mcom.TenantID) *bm.TenantSettings {
	ta.Helper()
	return edb.Get[bm.TenantSettings](ta.RC(), tenantID)
}
```

Now... this is just laziness, because we have this in fdb:

```go
func LoadShopSettings(txish edb.Txish, tenantID bm.TenantID) *bm.TenantSettings {
	settings := edb.Get[bm.TenantSettings](txish, tenantID)
	if settings == nil {
		settings = bm.DefaultTenantSettings(tenantID)
	}
	settings.XNormalize()``
	return settings
}
```

...which is how we load settings in real code, and seems to be perfectly fine for use in tests. We can even pass ta as edb.Txish, so exactly the same signature.

Verdict: delete and use fdb.LoadShopSettings.


## Example (most important): `assertDisabledConfigStillHasAllData`

```go
// Helper: Asserts disabled config still has all data
func assertDisabledConfigStillHasAllData(ta *firetesting.App, config mreferrals.ReferralConfiguration, original *bm.TenantSettings) {
	ta.Helper()

	assert.False(ta, config.IsReferralsEnabled)
	assert.DeepEqual(ta, config.ReferrerReward, original.ObsoleteReferrerReward)
	assert.OK(ta, config.ReferrerReward.Pts > 0)
}
```

Surface level issues:

1. Useless comment (WTF really)
2. Multiple assertions inside a helper with a text comment. Failures will be reported on the line calling the helper, and it's hard to tell what failed.

So our first iteration is:

```go
func assertDisabledConfigStillHasAllData(ta *firetesting.App, config mreferrals.ReferralConfiguration, original *bm.TenantSettings) {
	ta.Helper()
	assert.False(ta, config.IsReferralsEnabled, "IsReferralsEnabled")
	assert.DeepEqual(ta, config.ReferrerReward, original.ObsoleteReferrerReward, "ReferrerReward")
	assert.OK(ta, config.ReferrerReward.Pts > 0, "ReferrerReward.Pts")
}
```

This is good, but not what we came here for. Is this a good helper? Let's look at its sole usage:

```go
func TestMigration_referrals_v2_to_v3_disabled_but_configured(t *testing.T) {
	ta := firetesting.Setup(t, &firetesting.Options{})

	disabledButConfiguredSettings := createDisabledButConfiguredSettings()
	rawSettingsBytes := serializeV2Settings(ta, disabledButConfiguredSettings)

	migratedSettings := deserializeAndMigrateToV3(ta, rawSettingsBytes)

	assertConfigurationCreatedEvenWhenDisabled(ta, migratedSettings)
	assertDisabledConfigStillHasAllData(ta, migratedSettings.ReferralConfigurations[0], disabledButConfiguredSettings)
}
```

Is this a desirable style of tests? On a surface level, it reads like a prose, just like we asked. However, it might be _too much_ like a prose, because reading the test does not actually tell you the technical substance of what is going on!

Here we come to the primary guidance: helpers should increase the abstraction level of a test, hiding unimportant details, but should NOT go to a level where the test's code loses all substance.

Here's a more extreme example to illustrate the point:

```go
func TestMigration_referrals_v2_to_v3_disabled_but_configured(t *testing.T) {
	ta := firetesting.Setup(t, &firetesting.Options{})
	assertV3MigrationSucceeds(ta)
}
```

Is this a good test? It is easy to read for sure, but reading it gives you absolutely no clue of what it is testing, beyond what's already in the test name.

It could still be a good idea, if we had a series of tests like this:

```go
func TestMigration_referrals_v2_to_v3_some_option_disabled(t *testing.T) {
	ta := firetesting.Setup(t, &firetesting.Options{
		SomeOption: false,
	})
	assertV3MigrationSucceeds(ta)
}
func TestMigration_referrals_v2_to_v3_some_option_enabled(t *testing.T) {
	ta := firetesting.Setup(t, &firetesting.Options{
		SomeOption: true,
	})
	assertV3MigrationSucceeds(ta)
}
func TestMigration_referrals_v2_to_v3_yet_another_setup(t *testing.T) {
	ta := firetesting.Setup(t, &firetesting.Options{
		AnotherOption: 42,
	})
	assertV3MigrationSucceeds(ta)
}
```

Here, we have a good reason to extract the repetitive body into a single func. It's like a form of a table test, but we have different setup code so better to write it as a series of tests.

However, that's not the case in the code being reviewed. In that specific `TestMigration_referrals_v2_to_v3_disabled_but_configured`, all substance has been moved into `assertConfigurationCreatedEvenWhenDisabled` and `assertDisabledConfigStillHasAllData`, leaving nothing for the test itself -- and this test is the only place where these helpers are used.

Now, a single-use helper is not BY ITSELF a bad abstraction. Sometimes, that helper is still a useful abstraction tool. So the key thing here is comparing the abstraction level of the test code with the abstraction level of its helpers.

We want our abstractions to carry 3 desirable properties:

1. There's a staircase of abstraction: the outer test code speaks the highest level, while the helpers it calls are on a substantially lower level, and the subhelpers those might be calling at on a substantially lower level still.

2. We see coupling and cohesion changing in step with the level of abstraction: lower-level abstractions have significantly lower coupling (ie speak to a subset of the system that the outer code speaks to) and significantly higher cohesion (ie handle a significantly smaller chunk of responsibilities — ultimately “does one thing and does it well” maxima).

3. The abstraction is generic enough to be usable across multiple use cases. ( This more or less follows from the prior two principles, but is worth considering on its own to avoid weirdly specific abstractions.) This not simply helps with reuse, but ensures that all those various places handle the same need with exactly the same code.

With these 3 principles in mind, let's consider a few good and bad examples of tests.

Here's an example of a great test:

```go
func TestProcessCustomers_space_in_email(t *testing.T) {
	t.Parallel()
	ta := firetesting.Setup(t, &firetesting.Options{})

	c1, _, _, _ := firetesting.UpdateCustomer(ta, &bpub.Customer2{
		ExtID:     "",
		FirstName: "Alice",
		LastName:  "In Wonderland",
		Email:     "alice@example.com ",
	}, processing.FullUpdate, processing.CustomerUpdateOptions{
		Origin: bpub.DataOriginImport,
	})
	assert.Eq(t, c1.Email, "alice@example.com")
}
```

This test is very specific technically -- its title explains the purpose, and then all technical details of what exactly it does is right here in the body. At the same time, the abstraction level is pretty high — there are no complicated irrelevant details here, we do an update and verify its result.

It calls into `firetesting.UpdateCustomer` helper which handles the boring details:

```go
func UpdateCustomer(ta *App, in *bpub.Customer2, mode processing.UpdateMode, opt processing.CustomerUpdateOptions) (*bm.Customer, *bm.CustomerStatsOverall, processing.Pristinity, fireerr.UnidentifiableCustomerError) {
	ta.Helper()
	var cust *bm.Customer
	var cs *bm.CustomerStatsOverall
	var prist processing.Pristinity
	var err fireerr.UnidentifiableCustomerError
	ta.Update(func() {
		proc := NewProcessor(ta)
		defer proc.Finalize()
		cust, cs, prist, err = proc.UpdateCustomer(in, mode, opt)
	})
	return cust, cs, prist, err
}
```

This helper is:

1. Has a significantly different abstraction level: it deals with the details of updating a customer, rather than overall “what needs to be done” level of the test.
2. Has a low coupling: only speaks to the processing subsystem and does not, for example, concern itself with tenant setup.
3. Has a high cohesion: really only performs a single function. If say `proc.UpdateCustomer` didn't return the updated customer, one could imagine the same helper being responsible for loading the updated customer data, so that the outer test doesn't need to handle that boring task, and it would still be highly related to a customer update, so still very high cohesion.
4. Reusable across multiple use cases that need to update a customer for various reasons.

Finally, this helper in turn calls into `NewProcessor` helper:

```go
func NewProcessor(ta *App) processing.Processor {
	return processing.New(ta.RC(), ta.Venue())
}
```

which is again a hugh drop down in abstraction level, has even lower coupling and exactly one narrow responsibility. Still, it's a good helper because it hides uninteresting details of Processor creation and enforces all users of Processor within tests to follow the same creation pattern, ensuring that all higher-level helpers are can be multivenue-compatible for free.

Let's now consider this couple of tests:

```go
func TestMerge_empty(t *testing.T) {
	t.Parallel()
	ta := firetesting.Setup(t, &firetesting.Options{})
	alice := firetesting.AddFixture(ta, fixtures.Customer)
	bob := firetesting.AddFixture(ta, fixtures.Customer)
	ta.SaveFixtures()

	merge(ta, alice, bob)
	fireassert.Pts(ta, alice, 0)
}

func TestMerge_pts(t *testing.T) {
	t.Parallel()
	ta := firetesting.Setup(t, &firetesting.Options{})
	alice := firetesting.AddFixture(ta, fixtures.Customer)
	bob := firetesting.AddFixture(ta, fixtures.Customer)
	ta.SaveFixtures()

	firetesting.GivePts(ta, bob, 200)
	fireassert.PointChangeCount(ta, alice, 0)
	fireassert.PointChangeCount(ta, bob, 1)

	merge(ta, alice, bob)
	fireassert.PointChangeCount(ta, alice, 1)
	fireassert.PointChangeCount(ta, bob, 0)
	fireassert.Pts(ta, alice, 200)
	fireassert.Pts(ta, bob, 0)
}
```

These are easy to read and understand deeply, because:

1. The `merge` helper is at a similar abstraction level, so could potentially make the test harder to understand. However, it is reused across multiple tests, and is entirely boring — which is another way of saying that it has very low coupling and very high cohesion. Merging is fundamentally a bunch of related boring calls:

    ```go
    func merge(ta *firetesting.App, dest *bm.Customer, src *bm.Customer) {
     	ta.Helper()
     	ta.Update(func() {
    		proc := firetesting.NewProcessor(ta)
    		coremerging.MergeOne(proc, dest, src, "", false)
    		coremerging.FinalizeMerge(proc, dest)
    		proc.Finalize()
     	})
    }
    ```

2. Other helpers (`AddFixture`, `SaveFixtures`, `GivePts`, `...assert.PointChangeCount`, `...assert.Pts`) are all at a much different level of abstraction, and also have very low coupling and very high cohesion.

Now, compare this to the migration test from above:

```go
func TestMigration_referrals_v2_to_v3_disabled_but_configured(t *testing.T) {
	ta := firetesting.Setup(t, &firetesting.Options{})

	disabledButConfiguredSettings := createDisabledButConfiguredSettings()
	rawSettingsBytes := serializeV2Settings(ta, disabledButConfiguredSettings)

	migratedSettings := deserializeAndMigrateToV3(ta, rawSettingsBytes)

	assertConfigurationCreatedEvenWhenDisabled(ta, migratedSettings)
	assertDisabledConfigStillHasAllData(ta, migratedSettings.ReferralConfigurations[0], disabledButConfiguredSettings)
}
```

Observe that all helpers that it calls are (1) at about the same level of abstraction, (2) are weirdly specific to this particular test.

There is another big problem with these helpers, though: they all lie.

In fact, what do they even do? The intention is clear enough; `serializeV2Settings` should serialize settings to bytes in V2 format, then `deserializeAndMigrateToV3` should read those bytes in V3 format. But... is that what's actually going on?

```go
// Helper: Serializes V2 settings with version 2
func serializeV2Settings(ta *firetesting.App, settings *bm.TenantSettings) []byte {
	ta.Helper()

	// Simulate V2 structure by setting version
	type v2Wrapper struct {
		Version uint64 `msgpack:"_v"`
		*bm.TenantSettings
	}
	v2 := v2Wrapper{Version: 2, TenantSettings: settings}

	rawBytes := fu.Must(msgpack.Marshal(v2))
	return rawBytes
}
```

Um... what? Why? What is mixing `_v` into the settings supposed to accomplish? What exactly are we simulating? If we meant to simulate what edb does — that's not what it does. We effectively `msgpack.Marshal` here with some bonus nonsense.

Now does `deserializeAndMigrateToV3` read that `_v` field somehow? No:

```go
// Helper: Deserializes and triggers migration to V3
func deserializeAndMigrateToV3(ta *firetesting.App, rawBytes []byte) *bm.TenantSettings {
	ta.Helper()

	var settings bm.TenantSettings
	fu.Ensure(msgpack.Unmarshal(rawBytes, &settings))

	// TenantID is not serialized (msgpack:"-"), so we need to set it
	// before migration since UpgradeToV3 uses it to generate config ID
	settings.TenantID = testTenantID

	// Trigger migration
	settings.UpgradeToV3()

	return &settings
}
```

So we effectively `msgpack.Marshal`, then `msgpack.Unmarshal` and call `UpgradeToV3`. We've hidden nonsensical details within helpers with plausible-sounding names. This was lame.

Instead of:

```go
	disabledButConfiguredSettings := createDisabledButConfiguredSettings()
	rawSettingsBytes := serializeV2Settings(ta, disabledButConfiguredSettings)

	migratedSettings := deserializeAndMigrateToV3(ta, rawSettingsBytes)
```

we could just do:

```go
	disabledButConfiguredSettings := createDisabledButConfiguredSettings()
	disabledButConfiguredSettings.UpgradeToV3()
```

So far so good. `createDisabledButConfiguredSettings` is weirdly specific too, though:

```go
func createDisabledButConfiguredSettings() *bm.TenantSettings {
	settings := createV2SettingsWithAllFields()
	settings.ObsoleteReferralsEnabled = false
	return settings
}
```

Is it helpful to hide that single assignment line? No, it would actually be clearer to see it inline.

Now let's talk about `disabledButConfiguredSettings`. Clear names can be very useful, but as Go experts know, sometimes you want `i` instead of a full name. So the long names are not a univeral good. Does the name help in this case? No, it does not; there is only one settings instance in this test, and the test is called `..._disabled_but_configured`, so of course the settings would be disabled but configured. We're calling attention to a detail that is not actually notable, like a trickster deflecting attention away from the real sleight of hand. (And given the bullshit other helpers were doing, the analogy is surprisingly apt.)

So far we have:

```go
func TestMigration_referrals_v2_to_v3_disabled_but_configured(t *testing.T) {
	ta := firetesting.Setup(t, &firetesting.Options{})

	settings := createV2SettingsWithAllFields()
	settings.ObsoleteReferralsEnabled = false
	settings.UpgradeToV3()

	assertConfigurationCreatedEvenWhenDisabled(ta, settings)

	original := createV2SettingsWithAllFields()
	assertDisabledConfigStillHasAllData(ta, settings.ReferralConfigurations[0], original)
}
```

Now what does `assertConfigurationCreatedEvenWhenDisabled` even do? Note that it has a very long name, becuse it has a very muddy function that is hard to explain. Let's see if we inline it and `assertDisabledConfigStillHasAllData`:

```go
func TestMigration_referrals_v2_to_v3_disabled_but_configured(t *testing.T) {
	original := createV2SettingsWithAllFields()
	settings := createV2SettingsWithAllFields()
	settings.ObsoleteReferralsEnabled = false
	settings.UpgradeToV3()

	assert.Eq(t, len(settings.ReferralConfigurations), 1)

	c := settings.ReferralConfigurations[0]
	assert.False(t, c.IsReferralsEnabled)
	assert.DeepEqual(t, c.ReferrerReward, original.ObsoleteReferrerReward)
	assert.OK(t, c.ReferrerReward.Pts > 0)
}
```

We took advantage of ability to extract a common `c` variable, and now the test uses a fairly typical pattern — verifying the content of an array. While at it, let's remove `c.ReferrerReward.Pts > 0` which tests `createV2SettingsWithAllFields` helper, not the upgrade behavior, and we're left with a very simple, clear and straightforward test:

```go
func TestMigration_referrals_v2_to_v3_disabled_but_configured(t *testing.T) {
	original := createV2SettingsWithAllFields()
	settings := createV2SettingsWithAllFields()
	settings.ObsoleteReferralsEnabled = false
	settings.UpgradeToV3()

	assert.Eq(t, len(settings.ReferralConfigurations), 1)

	c := settings.ReferralConfigurations[0]
	assert.False(t, c.IsReferralsEnabled)
	assert.DeepEqual(t, c.ReferrerReward, original.ObsoleteReferrerReward)
}
```

This keeps `createV2SettingsWithAllFields` helper, but gets rid of everything that made it muddy, and we're left with the code that easier to read than the original.

This is what good engineering is.
