
#import "CPTextStyle.h"
#import "CPColor.h"

/** @brief Wrapper for various text style properties.
 **/

@implementation CPTextStyle

/** @property fontSize
 *  @brief Sets the font size.
 **/
@synthesize fontSize;

/** @property fontName
 *  @brief Sets the font name.
 **/
@synthesize fontName;

/** @property color
 *  @brief Sets the current text color.
 **/
@synthesize color;

#pragma mark -
#pragma mark Initialization and teardown

-(id)init 
{
	if ( self = [super init] ) {
		self.fontName = @"Helvetica";
		self.fontSize = 12.0f;
		self.color = [CPColor blackColor];
	}
	return self;
}

-(void)dealloc
{
	self.fontName = nil;
	self.color = nil;
	[super dealloc];
}

#pragma mark -
#pragma mark Factory Methods

/** @brief Creates and returns a new CPTextStyle instance.
 *  @return A new CPTextStyle instance.
 **/
+(CPTextStyle *)textStyle
{
	return [[[self alloc] init] autorelease];
}

#pragma mark -
#pragma mark Copying

-(id)copyWithZone:(NSZone *)zone 
{
	CPTextStyle *newCopy = [[CPTextStyle allocWithZone:zone] init];
	newCopy.fontName = self.fontName;
	newCopy.color = self.color;
	newCopy.fontSize = self.fontSize;
	return newCopy;
}

#pragma mark -
#pragma mark NSCoding methods

-(void)encodeWithCoder:(NSCoder *)coder
{
	[coder encodeObject:self.fontName forKey:@"fontName"];
	[coder encodeDouble:self.fontSize forKey:@"fontSize"];
	[coder encodeObject:self.color forKey:@"color"];
}

-(id)initWithCoder:(NSCoder *)coder
{
    if ([[super class] conformsToProtocol:@protocol(NSCoding)]) {
        self = [(id <NSCoding>)super initWithCoder:coder];
    } else {
        self = [super init];
    }
    
    if (self) {
		self.fontName = [coder decodeObjectForKey:@"fontName"];
		self.fontSize = [coder decodeDoubleForKey:@"fontSize"];
		self.color = [coder decodeObjectForKey:@"color"];
	}
    return self;
}

@end
