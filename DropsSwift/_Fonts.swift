//
//  _Fonts.swift
//  DropsSwift
//
//  Created by Mahan on 4/30/19.
//  Copyright © 2019 Nizek. All rights reserved.
//

import UIKit

class _Fonts: NSObject {
    
    func isArabic() -> Bool
    {
        return helper.getLang() == "ar";
    }
    
    func _FontOfSize(size : CGFloat) -> UIFont?
    {
        return isArabic() ? UIFont(name: "GESSTwoLight-Light", size: size) : UIFont(name: "HelveticaNeue-Light", size: size)
    }
    
    func _MediumFontOfSize(size : CGFloat) -> UIFont?
    {
        return isArabic() ? UIFont(name: "GESSTwoMedium-Medium", size: size) : UIFont(name: "HelveticaNeue-Medium", size: size)
    }
    
    func _BoldFontOfSize(size : CGFloat) -> UIFont?
    {
        return isArabic() ? UIFont(name: "GEEast-ExtraBold", size: size) : UIFont(name: "HelveticaNeue-Bold", size: size)
    }
    
    func _SemiBoldFontOfSize(size : CGFloat) -> UIFont?
    {
        return isArabic() ? UIFont(name: "GESSTwoMedium-Medium", size: size) : UIFont(name: "HelveticaNeue-Medium", size: size)
    }
    
    func _LightFontOfSize(size : CGFloat) -> UIFont?
    {
        return isArabic() ? UIFont(name: "GESSTwoLight-Light", size: size) : UIFont(name: "HelveticaNeue-Light", size: size)
    }
    
    func _ItalicFontOfSize(size : CGFloat) -> UIFont?
    {
        return isArabic() ? UIFont(name: "GESSTwoLight-Light", size: size) : UIFont(name: "HelveticaNeue-Italic", size: size)
    }
    
    func _MediumItalicFontOfSize(size : CGFloat) -> UIFont?
    {
        return isArabic() ? UIFont(name: "GESSTwoMedium-Medium", size: size) : UIFont(name: "HelveticaNeue-MediumItalic", size: size)
    }
    
    func _CondensedBoldFontOfSize(size : CGFloat) -> UIFont?
    {
        return isArabic() ? UIFont(name: "GESSTwoMedium-Medium", size: size) : UIFont(name: "HelveticaNeue-CondensedBold", size: size)
    }
    
    func _SemiBoldItalicFontOfSize(size : CGFloat) -> UIFont?
    {
        return isArabic() ? UIFont(name: "GEEast-ExtraboldItalic", size: size) : UIFont(name: "HelveticaNeue-MediumItalic", size: size)
    }
    
    // Arabic
    
    func _ArabicFontOfSize(size : CGFloat) -> UIFont?
    {
        return UIFont(name: "GESSTwoLight-Light", size: size)
    }
    
    // English
    
    func _EnglishFontOfSize(size : CGFloat) -> UIFont?
    {
        return UIFont(name: "HelveticaNeue-Light", size: size)
    }
    
    //
    
    func _FontOfSize(size : CGFloat, isArabic : Bool) -> UIFont?
    {
        return isArabic ? _ArabicFontOfSize(size: size) : _EnglishFontOfSize(size: size)
    }
}
