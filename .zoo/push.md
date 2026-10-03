Do NOT run the scout during rebase/push flows.

After push, if the pushed commit resolves a ticket (“Resolves DEV-1234, fixes DEV-1234”, etc), and the ticket is In Progress or in QA Rejected status, move it to 'Awaiting Dev Deploy' status (you are allowed to update Linear status as a explicitly authorized exception here). Also verify that info from 'Ticket update' has landed as a ticket comment in some shape or form (might be trimmed down and rephrased, landing partially is enough, user exercises judgement), tell user in all caps as a final message: REMINDER: POST TICKET UPDATE COMMENT.
