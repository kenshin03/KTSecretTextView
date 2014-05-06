### View management

Do not use interface builder for production code; instead, override -loadView.
Use autolayout when possible.

### Comments

```
/*!
 *  Method comment.
 *  Start this with a command verb (i.e. “Initialize”, “Compare”).
 *  Use periods.
 *
 *   @param <name> <description>
 *
 *   @return <description>
 */
```

Public interface should contain comments for methods. Private methods that aren’t implementing protocol methods should have comments. Don’t declare private methods outside of the implementation.


// Private comment. Again, make sure to use periods.

Comment confusing or non-trivial code inside a method. Reference issues on GitHub if code fixes a specific bug.


// TODO: Fix this problem. #42

If a method is missing code pending a later fix or feature, reference the GitHub issue.

### Constants

.h: extern NSString *const kPREFIXPublicConstantString

.m: NSString *const kPREFIXPublicConstantString = @”My Constant String”;

.m: NSString *const kMyPrivateConstantString = @”My Private String”;



### Static variables

static UIInteger sMyStaticVar;

### Imports

```
#import “MyClass.h”
#import “Alphabetical.h”
#import “Order.h”
#import <AngleBracketImports/AtEnd.h>

```
Alphabetize header imports by section. Start with the class definition, then internal imports, then external imports with angle brackets.

### Delegates/protocols

Self should always be the first parameter in delegate methods.

```
- (void)myObject:(PREFIXMyObject *) didDoSomethingWithNumber:(NSNumber *)number;
```

In interface declarations implementing more than one delegate, put each delegate name on its own line, in alphabetical order i.e.

```
@interface MyInterface () <
ADelegate,
BDelegate
>
```
### Event/action handlers
Noun describing view followed by past tense verb describing event. Optionally take sender or gesture recognizer if it’s used.

```
buttonTapped
cellSwipedRightWithGestureRecognizer:
```

### Properties
Use lazy instantiation pattern (in the getter) as much as possible.

Try to use private properties always instead of raw ivars. This is for consistency - we should be using lazy instantiation even on private variables (for example, private subviews), so let’s just use private properties for all private variables so we’re not mentally toggling between _privateVar1 and self.privateVar2.* Major exception is in init methods, where you should access the ivar directly (and obviously in the getter and setter). Avoid synthesize statements - use the default synthesizer provide by XCode 4.4+ (underscore + property name).

If you declare a property as readonly in the public .h @interface, redeclare it as readwrite in the private @interface. This ensures that the backing store ivar is actually created, and allows code in the .m file to write to the property without accessing the ivar directly.

Modifier order (for consistency): strong/weak, atomic/nonatomic, readonly/readwrite.

### Method calling syntax
Always use the dot syntax for setters and getters. Never use it for other methods.

### Initialization
Access ivars directly in initializers (this is the one place to do that).

All initialization must go through an explicitly-documented designated initializer. The comment should contain the string “This is the designated initializer.” If the designated initializer has a different method signature than its superclass's designated initializer, an initializer must be written that matches the method signature of the superclass's designated initializer (and calls the designated initializer, needless to say).


### Controller communication
Rules of thumb:

* Use delegates to communicate back to a controller some action/event that originated in the view (or whatever class).
* Use block to communicate back to a controller the result of some action explicitly taken by the controller on the view (or whatever class)


### File sections
Create hierarchy as follows:

```
#pragma mark - Public
#pragma mark - Class methods

Public
Class methods
Initialization
Public properties
Instance methods
Overrides
View lifecycle
Private
Private properties
Event handlers
<Something> protocols (datasource then delegate)
<Something> helpers (e.g. View lifecycle helpers)

```

#Misc. naming conventions

* “Count” variables should always end with the word “count” (fooCount, barCount, etc.)
* Methods for updating core data from the server should be called “<Model>With<Dictionary/Array>:” and return the created object or array of objects.


#Colors and styles

* Use a Stylesheet class with class methods.
* Style names should be specific to their usage.

#Brackets

* Always use curly braces around code blocks, even one liners.
* Put the opening curly brace on the same line except for methods.
* Use parentheses around multi-line expressions to help the auto-indenter do it’s thing.

#Auto layout
Use AutoLayoutShorthand and AutoLayoutHelpers to construct views. Construct initial view properties, like style, in a memoized property getter, i.e.:

```
- (UILabel *)topicLabel
{
    if (!_topicLabel) {
        _topicLabel = [UILabel new];
        _topicLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _topicLabel.font = [PREFIXFont searchResultCellSecondaryFont];
        _topicLabel.textColor = [PREFIXColor secondaryTextColor];
    }
    return _topicLabel;
}

```

View construction should be done in the following stages, in loadView for a view controller or init for a view:

```
self.view = [self mainView]; // View controllers
[self addSubviewTree]; // Add each view to the hierarchy
[self constrainViews]; // Individual methods to constrain each view
[self setupNavigationBar]; // Any navigation bar view/button/title customization

```


#Style
Colors should be defined in PREFIXColor. Prefer global themed style colors like secondaryBackgroundColor to custom defined colors per view.

Fonts should be defined inline in a view’s getter with UIFont fontWithName:size:. PREFIXFont is deprecated.





