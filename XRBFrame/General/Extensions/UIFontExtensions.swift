//
//  UIFontExtensions.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit

enum FontType: String {
    case none = ""
    case regular = "Regular"
    case bold = "Bold"
    case demiBold = "DemiBold"
    case light = "Light"
    case ultraLight = "UltraLight"
    case italic = "Italic"
    case thin = "Thin"
    case book = "Book"
    case roman = "Roman"
    case medium = "Medium"
    case mediumItalic = "MediumItalic"
    case condensedMedium = "CondensedMedium"
    case condensedExtraBold = "CondensedExtraBold"
    case semiBold = "SemiBold"
    case boldItalic = "BoldItalic"
    case heavy = "Heavy"
}

enum FontName: String {
    case helveticaNeue
    case helvetica
    case futura
    case menlo
    case avenir
    case avenirNext
    case didot
    case americanTypewriter
    case baskerville
    case geneva
    case gillSans
    case sanFranciscoDisplay
    case seravek
}

// MARK: - Methodss
extension UIFont {
    class func font(_ name: FontName, type: FontType, size: CGFloat) -> UIFont {
      // Using type
      let fontName = name.rawValue + "-" + type.rawValue
      if let font = UIFont(name: fontName, size: size) {
          return font
      }

      // That font doens't have that type, try .None
      let fontNameNone = name.rawValue
      if let font = UIFont(name: fontNameNone, size: size) {
          return font
      }

      // That font doens't have that type, try .Regular
      let fontNameRegular = name.rawValue + "-" + "Regular"
      if let font = UIFont(name: fontNameRegular, size: size) {
          return font
      }

      return UIFont.systemFont(ofSize: size)
    }

    class func helveticaNeue(type: FontType, size: CGFloat) -> UIFont {
        return font(.helveticaNeue, type: type, size: size)
    }

    class func avenirNext(type: FontType, size: CGFloat) -> UIFont {
        return font(.avenirNext, type: type, size: size)
    }

    class func avenirNextDemiBold(size: CGFloat) -> UIFont {
        return font(.avenirNext, type: .demiBold, size: size)
    }

    class func avenirNextRegular(size: CGFloat) -> UIFont {
        return font(.avenirNext, type: .regular, size: size)
    }
}
