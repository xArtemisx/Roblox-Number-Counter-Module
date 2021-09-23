# Roblox-Number-Counter-Module
A simple Tweened TextLabel based NumberCounter for Roblox.

After struggling with Number Spinners and ultimately deciding it wasn't worth the hastle it'd entail to program a TextScaled supported Number Spinner, I decided on the much simpler alternative of a number counter instead. At it's core, this is simply a class for creating a gui based number display that smoothly tweens between values using its Time property. On top of this core functionality is a simple formatting option as well between the use cases I needed.

API:

Functions:

function Counter.fromLabel(Label, Format, StartingValue, Prefix)
Creates a NumberCounter object from the provided Label with the provided properties. Format can either be "Comma" (eg 1000 becomes 1,000) or "Abbrev" (eg 12500 becomes 12.5k). StartingValue is defined initially and therefore won't tween on the initial call. Prefix is an optional argument on what should be added before the number, in some cases you may want to add a plus, a minus, etc.

function Counter:UpdateValue()
The primary function for interfacing with the NumberCounter. Simply sets its target value and tweens over the given time.

function Counter:Destroy()
Destroys the NumberCounter object and disconnects all functions. Leaves the original TextLabel intact.

Properties:

number Time - The Amount of Time that the NumberCounter will tween to it's new value over.

string Prefix - The string prefix to be appended before the number

number Value - The Target Value of the number counter. Setting NumberCounter.Value directly is not advised as it doesn't call any update functions and will be overidden on the next :UpdateValue call.

string Format - Either "Comma" or "Abbrev" for the type of string formatting to be done on the displayed number.
