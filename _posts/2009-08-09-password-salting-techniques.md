---
id: 163
title: Password Salting Techniques
guid: http://www.andymadge.com/?p=163
header:
  image: assets/images/header-images/IMG_6570_w2500.jpeg
toc: true
categories:
  - Computers
  - Web Development
tags:
  - security
---
This article is about using salting techniques to improve the security of authentication for websites.  Examples are in PHP but the techniques apply to any language.

<!--more-->

{% capture caveat %}
## Caveat

Before I continue, I just want to make an important point:

The single best piece of advice I can give when building your own authentication system is...

  * Don't do it.

I don't mean don't use authentication, what I mean is that cryptographic techniques are complicated.  Actually they're extremely complicated.  If you don't have years of experience as a cryptographer, you're going to make mistakes that will leave security holes.  Guaranteed.

The alternative is to use a well respected authentication framework such as:

  * [PHPass](http://www.openwall.com/phpass/)
  * [Zend_Auth](http://framework.zend.com/manual/en/zend.auth.html){.broken_link} (requires Zend Framework)
  * [CodeIgniter Authentication Libraries](http://codeigniter.com/wiki/Category:Libraries::Authentication/){.broken_link} (require CodeIgniter)

[](http://www.openwall.com/phpass/)Frameworks such as this are developed by people who really do know what they are doing, and any security holes are generally quickly discovered and plugged.

I'm certainly no cryptographer, and this article is based on my current understanding.

That said, assuming you're going ahead anyway, let's get back to the article...
{% endcapture %}

<div class="notice--warning">{{ caveat | markdownify }}</div>

## Attacks

Let's look at the type of attacks we want to protect against.

### Dictionary

This involves having a list of common passwords and trying every one in turn.  Most dictionaries would contain millions of possibilities starting with obvious stuff like "password", "123456" and more obscure ones such as "pa$$wOrD" ([wikipedia entry](http://en.wikipedia.org/wiki/Dictionary_attack))

### Brute Force

This involves trying every possible password and in theory will always work against any system.  The problem is that it takes a LONG time to do.  As computing speed improves, obviously the time taken reduces.  Since you can't make brute force attacks impossible, what you want to achieve is to make them take an infeasibly long time - like years. ([wikipedia entry](http://en.wikipedia.org/wiki/Brute_force_attack))

### Rainbow Tables

This is a way of attacking hashed passwords.  The idea is that instead of calculating the hash of each password you want to try, you use a list of pre-calculated hashes, thus saving computation time. ([wikipedia entry](http://en.wikipedia.org/wiki/Rainbow_table))

## Password Storage

Bearing those in mind, let's look at the different ways you could store the password in your database:

### Plain Text

This is a massively bad idea.  If someone gets hold of your database, they know everybody's password.

NEVER EVER STORE PASSWORDS AS PLAIN TEXT.  ANYWHERE.  EVER.

One argument against this is "The spec requires that the password be stored in case someone forgets it."  If that's the case, then you should use reversible encryption and DON'T STORE THE ENCRYPTION KEY IN THE DATABASE.

### Hashed Passwords

A hash is a one-way algorithm that is commonly used in cryptography.  The idea is that there is no way to work backward to find out the password from the hash value.  There are many different hash algorithms, each with their own strengths and weaknesses. ([list of hash algorithms supported by PHP](http://uk3.php.net/manual/en/function.hash-algos.php))

The most commonly used hash functions are MD5 and SHA1:

```php
$password_hash = MD5( $password );
```

Lots of people will tell you that MD5 is sufficient for most uses, others will say that SHA1 is more secure so you should use that instead.

While these are two of the least-secure hashing algorithms, they are still secure enough for any normal website (i.e. not a bank etc.)

Other more secure hash algorithms are SHA256 or Whirlpool, but these have the disadvantage of taking longer to calculate.

So at this point, we're recommending:

```php
$password_hash = SHA1( $password );
```

## Vulnerabilities

Hashed passwords will provide complete protection against dictionary attacks.  They also protect effectively against brute force attacks since the operation would take an infeasibly long time, however they are still vulnerable to rainbow table attacks.

### Salting

Salting is a technique used to protect hashes against rainbow table attacks.  The idea is that an additional string - known as 'salt' - is introduced into the hash value:

```php
$salt = "abcd";
$password_hash = SHA1( $salt . $password );
```

So, if a rainbow table attack is successful, the attacker now still doesn't know the password, they know `$salt.$password`.  In this trivial example, the attacker would soon work out what the salt was - especially if they break another account - and then they would know the password.

Let's improve the salt...

```php
$salt = "ZvmLcZMXw3WIA78uudt9SFysSGocIF";
$password_hash = SHA1( $salt . $password );
```

Here we are using a random static string as the salt, which is definitely an improvement, but since the salt is static (i.e. the same for every user) then they still only need to work it out once.  After that, every user's account it vulnerable to the same attack.

Note that we could also hash the salt as follows:

```php
$salt = SHA1( "ZvmLcZMXw3WIA78uudt9SFysSGocIF" );
```

However, all this does is increase the computation time without significantly increasing the security.  The attacker only needs to find the value of `$salt` - it's completely irrelevant how it's calculated.

We need to make the salt different for each user.  One way is to use something that will be different for each user.  The most obvious thing is the username (or maybe email):

```php
$password_hash = SHA1( $username . $password );
```

This means that if two people have the same password, they will still have different password hashes.  If an attacker is successful with a rainbow table attack for one account, they know nothing about any of the other accounts on the system.

Better still, lets use a different randomly generated string as the salt for each user.  NOTE: In this case we're going to need to store the salt alongside the user in the database otherwise we have no way of checking it.

```php
$salt = random_string();
$password_hash = SHA1( $salt . $password );
```

`random_string` is a function defined elsewhere in your code.  There are good examples [here](http://stackoverflow.com/questions/48124/generating-pseudorandom-alpha-numeric-strings) and [here](http://911-need-code-help.blogspot.com/2009/06/generate-random-strings-using-php.html){.broken_link}.

Finally, let's combine some of the above into our best-yet version:

```php
$salt = random_string();
$password_hash = SHA1( $salt . MD5($email) . $password );
```

I know I said above that there's no point in hashing twice, but in this case it does have an effect - we don't want the salting algorithm to be obvious and now password hash doesn't contain anything that is recognizable as a word or email address.

It is important thing is that an attacker doesn't know exactly how you have introduced the salt.  As a result you need to be careful with Open Source software, since the salting algorithm will be plainly visible in the source code - although this is mitigated if the salt contains a random string.

There are many different approaches to salting - this is just one fairly simple version.  For anything that requires a higher level of security, you'll need to look at additional techniques.

As I mentioned above, I'm no security expert and I may have missed something.  If you think so, please let me know in the comment.

## Also...

This hasn't been the focus of the article but it's relevant - whenever someone creates an account, changes their password or logs in, you're going to be sending their password over the internet.  Unless you're using HTTPS/SSL, then the password will be sent IN THE CLEAR i.e. as plain text.

Anyone who is listening in with a packet sniffer will be able to see the password so all of your back-end security goes out the window.

You may think "OK, so I'll hash the password at the client using JavaScript before I send it."   This actually doesn't help at all - the attacker doesn't know the password, but he does know the hash, so he can use a replay attack which in most cases is good enough for their needs.

You can improve the security by using [Challenge-Response](http://en.wikipedia.org/wiki/Challenge_response) but the best alternative is to use SSL.