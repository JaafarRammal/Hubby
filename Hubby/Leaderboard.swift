//
//  Metric.swift
//  Hubby
//
//  Created by Jaafar Rammal on 05/02/2022.
//

import SwiftUI

struct UserCard: View {
    
    var name: String
    var device: String
    var score: String
    var rank: String
    
    var body: some View {
        HStack(alignment: .center) {
            Spacer()
                Text(rank)
                    .font(.system(size: 26, weight: .bold, design: .default))
                    .foregroundColor(.white)
            Spacer()
                Text(name)
                    .font(.system(size: 26, weight: .bold, design: .default))
                    .foregroundColor(.white)
                Text("(\(device))")
                    .font(.system(size: 18, weight: .bold, design: .default))
                    .foregroundColor(.white)
            Spacer()
            Spacer()
            Spacer()
                Text(score)
                    .font(.system(size: 26, weight: .bold, design: .default))
                    .foregroundColor(.white)
            Spacer()
        }
        .frame(maxWidth: .infinity, minHeight: 100, alignment: .center)
        .background(.teal)
        .modifier(CardModifier())
        .padding(.all, 20)
    }
}

struct Leaderboard: View {
    var body: some View {
        ScrollView(.vertical) {
            VStack{
                HStack {
                    Spacer()
                    Text("Leaderboard")
                        .font(.largeTitle)
                        .foregroundColor(.teal)
                    Spacer()
                    Image("two-blobs")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 80)
                        .padding(.all, 20)
                    Spacer()
                }
                ForEach(users, id: \.self) { user in
                    UserCard(name: user["name"]!, device: user["device"]!, score: user["score"]!, rank: user["rank"]!)
                }
            }
        }.frame(maxHeight: .infinity)
    }
}

struct Leaderboard_Previews: PreviewProvider {
    static var previews: some View {
        Leaderboard()
    }
}
