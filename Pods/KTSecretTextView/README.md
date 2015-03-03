#KTSecretTextView

`KTSecretTextView` is an attempt to re-create the text view in the app [Secret](http://secret.ly). Its clever designs and heavy use of gestures makes it very intuitive for users to customize their secret texts with textured backgrounds or photos. 

<!--
<div align="center">
<tr>
    <td>
        <img src="http://engineering.2359media.net/media/2014-04-16-rebuilding-instagram-feed-table-view/images/feed1.png" width="266" height="500" />
    </td>
    <td>
        <img src="http://engineering.2359media.net/media/2014-04-16-rebuilding-instagram-feed-table-view/images/feed2.png" width="266" height="500" />
    </td>
</tr>
</div>
-->

---
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

<!--
Read [Rebuilding Instagram feed table
view](http://engineering.2359media.net/blog/2014/04/16/rebuilding-instagram-feed-table-view/) to understand the challenges, difficulties, and how do we solve the issue of rebuilding the table view style popularized by Instagram app with Auto Layout.
-->


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



