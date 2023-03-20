//
//  Controllable.swift
//  
//
//  Created by 엄기철 on 2023/03/18.
//

import Foundation
import UIKit

/// Define input & output interface to communicate between parent and child.
public protocol Controllable { }

public protocol UIViewControllable: Controllable where Self: UIViewController { }
