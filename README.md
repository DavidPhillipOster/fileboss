# fileboss

An iOS app for moving files from Mac to iOS using Finder.

## How to use: Summary

### On the Mac:

Drag files from the Finder to **File Boss**’s icon in the Files pane of the iPhone’s Finder window.

Right click on a file to get a delete menu item.

### in the iOS app: 

Select files to send them to other apps.

Swipe on a file to delete.

## How to use: Details

It’s really easy to use, you'll see once you try it.

➊ In the Mac's Finder window for the iPhone

➋ In the Files pane

(You may need to select the Files from the » menu if your Finder window is small.)

➌ Click on the disclosure triangle for **File Boss**

➍ Drag files in from the Finder. The **File Boss** list will update when the copy is complete.

![Finder Screenshot](/readmeImages/FinderScreenshot.png)

➎ On your iPhone, in the **File Boss** app, tap on a file to get the Sharing sheet, and share with whatever app you like.

![iOS File Boss Screenshot](/readmeImages/iosScreenshot.png)


➏ To delete **File Boss**’s copy of a file, swipe it to the right.

### How it works:

**File Boss** makes its Documents directory available to the Finder (setting `UIFileSharingEnabled true` in its Info.plist)

### Compatibility : 

**File Boss** has been tested and works on iOS 9 through iOS 14.

### Build Instructions

Set the bundle ID to your bundle ID. Adjust the code signing.

### Versions

1/06/2021
First public source code release.

10/24/2020
Set min iOS to iOS 9 so I could run it on my iPod Touch. Everything worked.

10/12/2020
Fix bugs with delete caused by the previous fix. 

10/01/2020
Make header scroll with contents. (I tried using a tableHeader but couldn't get it to layout right.)

8/13/2020
V 1.2 - Sort the filenames. The O.S. doesn't do it for me. Refresh contents when becoming foreground.

7/08/2020 - started
V 1.1 - Add launch screen large icon. Add launch screen support for dark mode.

### License: 

Apache 2. See the LICENSE file in this repository.
