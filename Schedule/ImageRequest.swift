//
//  ImageRequest.swift
//  Schedule
//
//  Created by Carlos Loeza on 6/24/21.
//

import Foundation

struct ImageRequest : Encodable
{
    let attachment : Data
    let fileName : String
}
