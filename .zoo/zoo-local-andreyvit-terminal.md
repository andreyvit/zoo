Set cmux icon for ticket and task status on any Zoo task/subtask status change:

```sh
cmux set-status linear "DEV-1234" --icon ticket --color "#FAB387"
cmux set-status task "HL!" --icon list.bullet.rectangle --color "#94E2D5"
```

Always run both! If no ticket, show "none" as ticket badge.

Task statuses:
- HL - high level planning
- LL - low level planning
- HLU - high level stage spec uber review
- LLU - low level stage spec uber review
- E42 - executing subtask 42
- SUG - all subtasks finished but there are suggestions pending user review
- EXT - all subtasks previously finished but additional pending subtasks added per user request
- FIN - task finished without any pending suggestions or subtasks
- SQSH - squashing
- RBSE - rebasing
- PUSH - pushing

Use ? suffix when waiting on extra user input, ! when waiting for approval, ✓ when done, ex:
- HL? = high level planning waiting on user input.
- HL! = high level planning finished and waiting for approval
- SUG? = post-execution suggestions are awaiting user input
- SUG! = waiting for approval to continue execution after post-execution suggestions answered
- EXT! = waiting for approval to execute extra subtasks added on user request
- SQSH✓ = squash done (implies FIN usually)
- RBSE✓ = rebase done (implies FIN usually)
- PUSH✓ = push done
