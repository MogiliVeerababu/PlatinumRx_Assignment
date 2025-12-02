# Spreadsheet Task Solution

## 1. Populate `ticket_created_at` in feedbacks sheet

Formula used in feedbacks!B2:

=IFERROR(INDEX(ticket!$B$2:$B$1000, MATCH(A2, ticket!$E$2:$E$1000, 0)), "")

This formula fetches the ticket `created_at` based on matching `cms_id` from the ticket sheet.

---

## 2. Count tickets created & closed on the same day (outlet-wise)

Formula used in Results!B2:

=SUMPRODUCT((ticket!$D$2:$D$1000 = $A2) * (INT(ticket!$B$2:$B$1000) = INT(ticket!$C$2:$C$1000)))

This counts tickets where created and closed dates are the same.

---

## 3. Count tickets created & closed in the same hour of the same day (outlet-wise)

Formula used in Results!C2:

=SUMPRODUCT((ticket!$D$2:$D$1000 = $A2) * (INT(ticket!$B$2:$B$1000) = INT(ticket!$C$2:$C$1000)) * (HOUR(ticket!$B$2:$B$1000) = HOUR(ticket!$C$2:$C$1000)))

This counts tickets where created and closed times match in both date and hour.
