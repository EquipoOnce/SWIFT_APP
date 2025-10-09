//
//  EnvironmentExtension.swift
//  Testeo2.0
//
//  Created by Usuario on 06/10/25.
//

import Foundation
import SwiftUI

extension EnvironmentValues {
    @Entry var authController = AuthenticationController(httpClient:HTTPClient())
}
