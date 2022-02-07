//
//  Metric.swift
//  Hubby
//
//  Created by Jaafar Rammal on 05/02/2022.
//

import SwiftUI

struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 0)
    }
    
}

struct ProductCard: View {
    
    var image: String
    var title: String
    var type: String
    var price: String
    var score: String
    
    var body: some View {
        HStack(alignment: .center) {
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .padding(.all, 20)
                
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(size: 26, weight: .bold, design: .default))
                    .foregroundColor(.white)
                Text(type)
                    .font(.system(size: 16, weight: .bold, design: .default))
                    .foregroundColor(.white)
                Text("Score: \(score)")
                    .font(.system(size: 16, weight: .bold, design: .default))
                    .foregroundColor(.white)
                HStack {
                    Text(price)
                        .font(.system(size: 16, weight: .bold, design: .default))
                        .foregroundColor(.white)
                        .padding(.top, 8)
                }
            }.padding(.trailing, 20)
            Spacer()
        }
        .frame(maxWidth: .infinity,minHeight: 180, alignment: .center)
        .background(.teal)
        .modifier(CardModifier())
        .padding(.all, 20)
    }
}

struct Metric: View {
    var body: some View {
        ScrollView(.vertical) {
            VStack{
                
                HStack {
                    Spacer()
                    Text("Prizes")
                        .font(.largeTitle)
                        .foregroundColor(.teal)
                    Spacer()
                    Image("gift-blob")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 80)
                        .padding(.all, 20)
                    Spacer()
                }
                
                    
                ForEach(vouchers, id: \.self) { voucher in
                    Spacer()
                    ProductCard(image:voucher["picture"]!, title: voucher["company_name"]!, type: voucher["voucher_title"]!, price: voucher["voucher_code"]!, score: voucher["metric"]!)
                }
            }
        }.frame(maxHeight: .infinity)
    }
}

struct Metric_Previews: PreviewProvider {
    static var previews: some View {
        Metric()
    }
}
