#KTSecretTextView

`KTSecretTextView` is an attempt to re-create the text view in the app [Secret](http://secret.ly). Its clever designs and heavy use of gestures makes it very intuitive for users to customize their secret texts with textured backgrounds or photos. 

More on the creation of this text view here - http://corgitoergosum.net/2014/05/07/good-enough-isnt-replicating-the-secret-ios-app-text-view/.

---
##Video

<img src="https://raw.githubusercontent.com/kenshin03/KTSecretTextView/master/SecretTextView/Resources/Screenshots/KTSecretTextView-screencast.gif" width="320" height="568" />

---
##Screenshots

<div align="center">
<tr>
    <td>
        <img src="https://raw.githubusercontent.com/kenshin03/KTSecretTextView/master/SecretTextView/Resources/Screenshots/KTSecretTextView-screenshot1.png" width="266" height="500" />
    </td>
    <td>
        <img src="https://raw.githubusercontent.com/kenshin03/KTSecretTextView/master/SecretTextView/Resources/Screenshots/KTSecretTextView-screenshot2.png" width="266" height="500" />
    </td>
</tr>
<tr>
    <td>
        <img src="https://raw.githubusercontent.com/kenshin03/KTSecretTextView/master/SecretTextView/Resources/Screenshots/KTSecretTextView-screenshot3.png" width="266" height="500" />
    </td>
    <td>
        <img src="https://raw.githubusercontent.com/kenshin03/KTSecretTextView/master/SecretTextView/Resources/Screenshots/KTSecretTextView-screenshot4.png" width="266" height="500" />
    </td>
</tr>
</div>

---

##Features

- Scroll horizontally to choose between 8 types of background colors (Emerald Sea, Hopscotch, Lavender, Burst, Cupid, Peony, Midnight, White).
- Long Press to choose color from a compressed palette.
- Swipe vertically to choose between 6 types of textures (Glow, Linen, Lines, Noise, Squares, Squares2)
- Take a photo or choose one from Camera Roll as background.
- Pan left/right/up/down to vary the blurriness and dimmness of the background image.
- Text will attempt to align to the center vertically.

##Installation

Add this to your Podfile to use `KTSecretTextView`:
	
	pod 'KTSecretTextView', '~> 0.0.1'


##Usage

The`KTSecretViewController` class is a wrapper you can present or push to your view controller stack. The provided sample app simply presents it as a modal as shown below.

Adding `KTSecretViewController` to imports:

     #import "KTSecretViewController.h"

Presenting the view controller on the tap of a button:

    KTSecretViewController *secretVC = self.secretViewController;

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:secretVC];

    [self presentViewController:navigationController animated:YES completion:nil];

To capture outputs from `KTSecretTextView`, vend for a delegate:

    @interface KTSecretTextViewSampleViewController ()<
    KTSecretViewControllerDelegate
    >
    
And implement the delegate method which provides a convenient snapshot view containing the edited background and text, as well as the actual attributed string and processed background image. You can make a `UIImage` from the snapshot view and save it as needed.

    - (void)secretViewController:(KTSecretViewController*)vc secretViewSnapshot:(UIView*)snapshotView backgroundImage:(UIImage*)backgroundImage attributedString:(NSAttributedString*)attributedString
    


---
##Background

Read [my post](http://corgitoergosum.net/2014/05/07/good-enough-isnt-replicating-the-secret-ios-app-text-view/) on how the Text View was built.

---
##Credits
The following Pods are used: 

* [UIImage-Resize](https://github.com/AliSoftware/UIImage-Resize) by [AliSoftware](olivier.halligon+ae@gmail.com)


___
##License
`KTSecretTextView` is available under the MIT license. 

___
##Feedback
File an issue or pull request. Or ping me at [@kenshin03](http://twitter.com/kenshin03).



