//: Playground - noun: a place where people can play

import UIKit

var str = "75 + 93.5"
var acc = "93.5"

var newStr = "-" + String(acc)
str = str.replacingCharacters(in: str.range(of: String(acc))!, with: newStr)


