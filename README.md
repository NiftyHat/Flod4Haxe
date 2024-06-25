# Flod 4.1 for Haxe

Port of the flod library 4.1 https://github.com/photonstorm/Flod to Haxe using ax3 https://github.com/innogames/ax3

The AS3 source included is the source as modified to run through ax3 which requires the following modifications
- All lines are properly terminated with a semicolon
- ifelse statements scoped with curly braces (weirdly ax3 is fine with single line conditionals unless they include an ifelse statement)
- remove all the multi line declarations

Additionall the following modifications where made to make the code port a little more clean
- Some static variables are strictly typed.