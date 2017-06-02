param(
	[string]$email,
	[string]$attachment,
	[string]$jobname,
	[string]$rulename,
	[string]$snapshotname,
	[string]$processname,
	[string]$url
	)

$emailSmtpServer = "smtp.office365.com"
$emailSmtpServerPort = "587"
$emailSmtpUser = "rjimenez@thehackettgroup.com"
$emailSmtpPass = "password"
 
$emailMessage = New-Object System.Net.Mail.MailMessage
$emailMessage.From = "CAF Support <rjimenez@thehackettgroup.com>"
$emailMessage.To.Add( "$email" )
$emailMessage.Subject = "PBCS Notifications - Process failed"
$emailMessage.IsBodyHtml = $true
$emailMessage.Body = @"
<p>The PBCS process <i>$jobname $rulename $snapshotname $processname </i> has <strong>failed</strong>.</p>
<p>Find attached the log.</p>
<p>For further details go to $url </p>
<p>The Hackett Group - Cloud Automation Framework </p>
"@
 
$SMTPClient = New-Object System.Net.Mail.SmtpClient( $emailSmtpServer , $emailSmtpServerPort )
$SMTPClient.EnableSsl = $true
$SMTPClient.Credentials = New-Object System.Net.NetworkCredential( $emailSmtpUser , $emailSmtpPass );

$emailMessage.Attachments.Add( $attachment )

$SMTPClient.Send( $emailMessage )
