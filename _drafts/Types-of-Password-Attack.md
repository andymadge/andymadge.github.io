---
id: 181
title: Types of Password Attack
date: 2014-03-13T19:25:05+00:00
author: AndyM
layout: post
guid: http://www.andymadge.com/?p=181
categories:
  - Computers
  - Security
---
This is a follow-on on from my article about [password salting](http://www.andymadge.com/2009/08/password-salting-techniques/). The descriptions of the attack types in that article were quite brief, and the wikipedia articles are a bit impenetrable. This is my attempt to explain them as simply as possible.

Also, I&#8217;m a firm believer in learning through teaching &#8211; explaining something requires a deeper level of understanding

Essentially there are two different situations to think about:

  1. An attacker has somehow got hold of your database via some sort of security hole. This might be lax permissions on the server, a disgruntled employee, an [SQL injection attack](http://en.wikipedia.org/wiki/SQL_injection), or myriad other ways.
  2. An attacker is attempting to log in as a user via the normal login screen of your app, but they don&#8217;t know the password so they have to guess.

In situation 1, they obviously have a massive amount of information at their disposal, and there are a lot of ways they can use it. Essentially, you&#8217;ve got a big problem. However, as long as you&#8217;re not storing the passwords as plain text, then they still don&#8217;t know any actual passwords. [Replay attacks](http://en.wikipedia.org/wiki/Replay_attack) may be possible depending on the design of your app, but that&#8217;s a whole different subject that I&#8217;m not going into here. (One-Time Tokens can guard against replay attacks) Situation 2 is more straightforward &#8211; the attacker is going to keep guessing passwords until they find the right one. Since they will be doing it through your login screen, they can only guess as quickly as your system responds. Also, you can implement an account lockout after a certain number of failed attempts. This is not a very effective way of attacking a system and any cracker would put their effort into getting a copy of your database. I&#8217;ll list the attacks in order of sophistication:

## Brute Force Attacks

This means trying every single possible password to see if it works. This works against almost all types of cryptography (except for something called a [One-Time Pad](http://en.wikipedia.org/wiki/One-time_pad)) The problem is that it takes a very, very long time to do. How long? Let&#8217;s see&#8230; WARNING: maths ahead. If you&#8217;re happy to take my word for it, skip this bit.

> Let&#8217;s assume that your system supports passwords containing any of the 95 printable ASCII characters (a-z, A-Z, 0-9, plus the punctuation) I&#8217;m ignoring [Unicode](http://en.wikipedia.org/wiki/Unicode) here for the sake of &#8216;simplicity&#8217;. If the password is 1 character, then there are 95 possible passwords. &#8211; It&#8217;s not going to take very long for a computer to try 95 different possibilities<img src="http://www.andymadge.com/blog/wp-includes/images/smilies/simple-smile.png" alt=":-)" class="wp-smiley" style="height: 1em; max-height: 1em;" /> If the password is 2 characters, then there are 95 x 95 = 9,025 possible passwords. &#8211; This is still not going to take very long. If the password is 3 characters, then there are 95 x 95 x 95 = 857,375 possible passwords. &#8211; We&#8217;re still in the range where a home computer can try all the possibilities in the blink of an eye. 8 characters gives 95^8 = 6,634,204,312,890,625 &#8211; Now we&#8217;re getting somewhere &#8211; 6.6 [quadrillion](http://en.wikipedia.org/wiki/Quadrillion "Quadrillion") possible passwords. If a computer can try a million every second, it&#8217;s going to take 210 years to try every password. 16 characters gives 95^16 = 44,012,666,865,176,569,775,543,212,890,625 also known as A Very Big Number Indeed. &#8211; That&#8217;s going to take 1,394,715,437,780,908,956,349,073 years, or to put it another way, 100 billion times the age of the universe. Just for the sake of completeness, note that assuming you try the passwords in random order, then on average, you&#8217;ll find the right password after half the attempts.

You can see that Brute Force is a very slow method. For 8 character passwords, even if your computer can try a billion passwords every second (not likely for a few years), it&#8217;s going to take over 2 months to try every one. At 16 characters, you&#8217;re still not even making a dent in the figures. Obviously there are organisations out there with very powerful (and expensive) computers that work faster than these examples by several orders of magnitude. Also, computers tend to [double in speed every 2 years](http://en.wikipedia.org/wiki/Moore's_law) but even so, the numbers are so vast that brute force attacks are to all intents and purposes, infeasible. That&#8217;s not to say people don&#8217;t succeed with them though &#8211; your job is to ensure that they don&#8217;t succeed with _your_ system!

## **Dictionary Attacks**

Having said all of that about brute force attacks, the truth is that people tend not to use long random strings of characters as their passwords. Humans find it easier to remember actual words. This reasoning is what gave rise to Dictionary Attacks. The idea is that rather than trying every possible password as you would for brute force, you try a much smaller set of the most likely passwords. So, a dictionary in this context is a long list of words that people could use as their password. Such dictionaries usually contain several million words and are easily available on the internet. Given the number of people who use &#8216;password&#8217; or their name as their password, it&#8217;s hardly surprising that this technique is very effective. Also, dictionaries will often contain words with common substitutions, such as

  * p4$$w0rD
  * e13pH4nt

As mentioned in the [previous article](http://www.andymadge.com/2009/08/password-salting-techniques/), password hashing is an effective way of protecting your database against dictionary attacks. However, this attack can still work if the attacker is able to feed their guesses through your login screen, but this will be slow, and can be easily foiled with an account lockout policy.

## Rainbow Tables

There seems to be a widely-held misconception that a rainbow table is a list of possible passwords with their corresponding hashes (which have been computed beforehand to save time) This is not a rainbow table, this is simply a dictionary with pre-computed hashes. The rainbow table is a far more elegant concept. Pre-computed hash tables save you computing time because the hashes are already calculated. However, this benefit comes at the expense of disk space. Disk space is cheap these days, but we&#8217;re talking about absolutely MASSIVE files here. Hash chains are the solution to this. This bit is going to get tricky, so prepare to exercise your brain!

### Hash Chains

The first concept we need to understand is the Hash Chain. First, a couple of definitions:

  * Hash function &#8211; takes a password, and spits out a hash value.
  * Reduction function &#8211; the opposite, it takes a hash value and spits out a _possible_ password.

Note that the reduction function is not the inverse of the hash function &#8211; that would be impossible since hash functions are one-way. The reduction function is just a function that takes a hash and generates a _possible_ password. Incidentally, the reduction function is one-way also. Ok, now you&#8217;re thinking &#8220;what&#8217;s the point in that then?&#8221; Well bear with me&#8230; From now on I&#8217;m going to refer to a &#8220;possible password&#8221; as a &#8220;plaintext&#8221;. A hash chain is a sequence of hash and reduction functions joined together. You start with a random plaintext, then you hash it, which gives a hash value. You then reduce the hash value and you have another plaintext. You then hash this, and so on. You&#8217;ve now got a line that goes:

<p style="padding-left: 30px;">
  plaintext1 ->; hash1 ->; plaintext2 ->; hash2 ->; plaintext3 ->; hash3
</p>

You can make these chains as long as you like &#8211; millions of iterations if you want. Then you start again with another random plaintext and generate another chain the same length. Once you have a lot of chains, you sort them by the final hash value, so it&#8217;s easy to look up. Then you throw away everything except the starting plaintext and ending hash, and you store it on disk. That&#8217;s your hash chain table. You&#8217;ve saved a massive amount of disk space by only storing the starting and ending values of each chain. NOTE: Longer chains mean less disk space to store the table, but more processing time during the actual attack, so in practice you would find a length to balance space against time. This is known as a [Space-Time tradeoff](http://en.wikipedia.org/wiki/Space-time_tradeoff). Now, if you want to crack a password hash, then you do this:

  1. Look for the hash in the &#8220;ending hash&#8221; column.
  2. If it&#8217;s there skip to step 5
  3. If it&#8217;s not there, apply the reduction function, then the hash function.
  4. Go back to step 1
  5. Once you&#8217;ve found the hash in the last column, look at the corresponding starting plaintext
  6. Keep applying the hash and reduction functions alternately until you find the original password hash.
  7. The immediately preceding plaintext is the password.

> NOTE: at step 5 you know that the password is the _preceding plaintext_ in that chain. You might be thinking you could use the reduction function to get it, but that doesn&#8217;t work. Remember, the reduction function actually moves _forward_ in the chain, giving you a _possible_ plaintext for that hash. We need the _actual_ one that occurred in the chain.

That&#8217;s how hash chains are used for cracking passwords. &#8220;Very clever&#8221; you say, &#8220;so that&#8217;s how rainbow tables work?&#8221; Err, not quite. Precomputed hash chains as described above have a big flaw &#8211; they are highly susceptible to collisions. This means that you can end up with the same hash value appearing in more than one of the chains. At this point the 2 chains merge into 1 and become far less effective. Rainbow tables take the concept of hash chains and tweaks it to reduce the chance of collisions. This is where it starts to get _really_ elegant&#8230; But this article is already very long, so I&#8217;m going to come back to it in my next post&#8230;