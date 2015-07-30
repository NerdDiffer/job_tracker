## company
company has many contacts
company has many job applications

## contact
contact belongs to one company
contact has many interactions
contact has many cover letters through interactions

## job application
job application has one company
job application has one posting
job application has one cover letter

## posting
posting belongs to job application

## cover letter
cover letter belongs to job application
cover letter has one contact, allow nil

## interaction
interaction belongs to contact
