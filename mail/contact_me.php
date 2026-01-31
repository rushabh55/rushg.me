<?php
// Basic honeypot check
if (!empty($_POST['website'])) {
    echo "Spam detected.";
    return false;
}

$name = isset($_POST['name']) ? trim($_POST['name']) : '';
$email_address = isset($_POST['email']) ? trim($_POST['email']) : '';
$phone = isset($_POST['phone']) ? trim($_POST['phone']) : '';
$message = isset($_POST['message']) ? trim($_POST['message']) : '';

// Require name + message + (email or phone)
if (empty($name) || empty($message) || (empty($email_address) && empty($phone))) {
    echo "No arguments Provided!";
    return false;
}

if (!empty($email_address) && !filter_var($email_address, FILTER_VALIDATE_EMAIL)) {
    echo "Invalid email.";
    return false;
}

// Create the email and send the message
$to = getenv('MAIL_TO') ? getenv('MAIL_TO') : 'admin@rushg.me'; // Override with MAIL_TO env var
$fromAddress = getenv('MAIL_FROM') ? getenv('MAIL_FROM') : 'noreply@yourdomain.com';
$email_subject = "Website Contact Form: $name";
$email_body = "You have received a new message from your website contact form.\n\n"."Here are the details:\n\nName: $name\n\nEmail: ".($email_address ?: 'N/A')."\n\nPhone: ".($phone ?: 'N/A')."\n\nMessage:\n$message";
$headers = "From: $fromAddress\n";
if (!empty($email_address)) {
    $headers .= "Reply-To: $email_address";
}
if (mail($to, $email_subject, $email_body, $headers)) {
    echo "OK";
    return true;
}
echo "Mail delivery failed.";
return false;
?>
