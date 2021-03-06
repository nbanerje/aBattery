#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "CPPlatformSpecificDefines.h"

@interface CPLayer : CALayer {
@private
	CGFloat paddingLeft;
	CGFloat paddingTop;
	CGFloat paddingRight;
	CGFloat paddingBottom;
}

/// @name Padding
/// @{
@property (nonatomic, readwrite) CGFloat paddingLeft;
@property (nonatomic, readwrite) CGFloat paddingTop;
@property (nonatomic, readwrite) CGFloat paddingRight;
@property (nonatomic, readwrite) CGFloat paddingBottom;
///	@}

/// @name Initialization
/// @{
-(id)initWithFrame:(CGRect)newFrame;
///	@}

/// @name Drawing
/// @{
-(void)renderAsVectorInContext:(CGContextRef)context;
-(void)recursivelyRenderInContext:(CGContextRef)context;
-(NSData *)dataForPDFRepresentationOfLayer;
///	@}

/// @name User Interaction
/// @{
-(void)mouseOrFingerDownAtPoint:(CGPoint)interactionPoint;
-(void)mouseOrFingerUpAtPoint:(CGPoint)interactionPoint;
-(void)mouseOrFingerDraggedAtPoint:(CGPoint)interactionPoint;
-(void)mouseOrFingerCancelled;
///	@}

/// @name Layout
/// @{
+(CGFloat)defaultZPosition;
///	@}


/// @name Bindings
/// @{
+(void)exposeBinding:(NSString *)binding;		
-(void)bind:(NSString *)binding toObject:(id)observable withKeyPath:(NSString *)keyPath options:(NSDictionary *)options;		
-(void)unbind:(NSString *)binding;		
-(Class)valueClassForBinding:(NSString *)binding;
///	@}

@end
