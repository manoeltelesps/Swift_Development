//
//  HistoricPhotoViewModel.swift
//  Cosmo
//
//  Created by Rodrigo Barbosa Pereira on 02/07/25.
//

import SwiftUI
import AVKit

struct HistoricVideoViewModel: View {
    let videoLink: String
    
    var body: some View {
        VStack {
            AVKitPlayerView(videoURL: URL(string: videoLink)!)
        }
        .frame(width: 320, height: 180)
        .cornerRadius(12)
    }
}


#Preview {
    HistoricVideoViewModel(videoLink: "https://images-assets.nasa.gov/video/GRC-2018-CM-0160-4_ACME-Hardware_Stocker/GRC-2018-CM-0160-4_ACME-Hardware_Stocker~orig.mp4")
}
