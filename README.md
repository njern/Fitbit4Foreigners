# README

**Fitbit has seen fit not distribute their [iOS client](http://itunes.apple.com/us/app/fitbit-activity-calorie-tracker/id462638897?mt=8) ) in Scandinavia nor many other countries so I wrote up a client using their API that aims to do most of the same things their client already does.**

**It's not very pretty but it does the job well enough.**

# Installation

Open the project in XCode, build it to your device.

# Getting started

Right now the application throws you straight into Mobile Safari to authenticate with Fitbit if you haven't done so already. In the future I am sure there'll be a fancy login screen but for now you will have to make do. 

*Hint*: I will also accept pull requests that "fixes" 
this flow :)

# Architecture

* Authentication happens via oAuth (if you want to use your own API keys, switch them out in *FitbitAuthorization.h* )
* Data is fetched from Fitbit's RESTful API on background threads.
* The main ViewControllers implement delegate methods that receive completed requests and redraw the view with fresh information.

# ARC Compatibility

Planned for a future release, if someone wants to implement it, your pull request *will* be accepted.