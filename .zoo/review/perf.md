Focus on performance:

1. No premature optimization, of course. Do complex weird optimization tricks only when measured or user explicitly requests it.
2. But no premature pessimization either: don't do something that you know is slow, when a fast alternative is not much harder.
3. We welcome machine empathy. Mind memory allocations, copying, interface wrapping. Don't allocate when zero-alloc path is not much more complex. Don't pass large structs by value (unless it's one time code like initialization, and you don't pass it far; we do sometimes pass configuration structs etc by value, paying single one-time copying hit to make code clearer; but this is outside of any hot paths).
4. Consider machine empathy when designing abstractions. We dislike abstractions that lock us into inefficient implementations that would be hard to change later. (Say you have 10k item list, and suddenly you want to convert each item to an interface, and if the interface is inconvenient, you might have to wrap each item in a struct and add a context pointer to each one -- yikes. It's better to build the interfaces with an efficient implementation in mind.)
5. Within hot paths and loops, we prefer only doing necessary allocations. (This basically is the balance between optimization and pessimization; we don't want to go to great lengths to eliminate all allocations, but we don't want to do unnecessary allocations where reasonably easy.)

'Background radiation' performance bottlenecks (i.e. when everything is running smoothly):

- for writes: I/O during commits (because all writing is blocked waiting on it)
- memory bandwidth
- for writes: queuing (writes are serialized, so waiting on each other)
- GC time, i.e. memory allocations
- msgpack unmarshalling when loading database rows
- heavy computations in write transactions (which is why we want to keep write transactions small)

Primary cause of memory allocations is iterating a lot of database rows. It's okay when we need to, though, it's just overwhelmingly the source of allocations, overshadowing anything else. Note that KV tables support zero-allocation and zero-unmarshalling reads.

So, when everything is properly implemented, the above determines the performance; and because we're running on huge dedicated servers with 1 TB RAM and about 300 GB allocated to Go heap, it's typically not a problem at all.

However, when we DO notice a performance bottleneck, it's typically because something else goes wrong:

1. Someone doing a full table scan or full index scan in a hot path. (Full scan is sometimes fine during maintenance.)

2. A long multi-hour read transaction running while a big bunch of writes happen; this causes Bolt to accumulate lots of pending pages, which it's not great at handling. So we'd like to avoid multi-hour read transactions where possible; i.e. if something can plausibly run for hours, it's best to break it down into smaller chunks. 10 min per read tx is the desired limit.

3. Accidentally doing an HTTP call inside a write tx.

4. And a special place in hell is for accidentally blocking app launch by running a long migration or pre-filling an index. We should improve edb and migration support to make these things easier.

5. Someone messing up caching during a large transaction is also an issue; when we start running out of that Go heap, GC time skyrockets. So make sure you understand memory usage bounds within a tx, making reasonable assumptions about number of tenants, number of objects, etc, and if a single tx starts eating over 20-50 GB heap, careful analysis of tradeoffs is needed. We should never use over 100 GB heap in a single tx, even a rare one-time one.

Finally. If user request, or the way we interpreted user request during planning, makes performance issues inevitable, we need to either replan if we have leeway, or stop and consult with the user if it was a hard requirement.
