aws-rest
========

An AWS REST client written in Dart!

I started this project because I wanted to make a deployment script for a dart project I'm working on.  I don't plan on actively maintaining it above and beyond what I need for my own deployment purposes, but I hope that someone may find it useful and contribute or clone it and improve upon it.  You might be wondering, "Why a REST client specifically for AWS?"  As it turns out, authorizing AWS REST requests [is not trivial](http://docs.aws.amazon.com/AmazonS3/latest/API/sig-v4-header-based-auth.html).  Having suffered through the process of implementing request signing for AWS authentication (incorrect documentation and all!), I hope that I can save someone else out there some pain!
