//
//  PackageRow.swift
//  FMSS
//
//  Created by Faruk Turgut on 23.02.2020.
//  Copyright © 2020 Faruk Turgut. All rights reserved.
//

import SwiftUI

//I tried to construct the view of each row in a seperate structure however It throws a unexpected runtime error. I know this the most productive way to build views as in seperating view constructors and being able to reuse the code. For this assignment It was more than enough to build the row in seperate function. But I would use this way in a more complex project. After find a solution for that runtime error.
//Fixed it. Could not be able to sleep otherwise. 
struct PackageRow: View {
    @EnvironmentObject var store: PackagesViewModel
    var package: PackageList.Package
    
    var body: some View {
        VStack {
            HStack{
                Text(self.package.name).font(.system(size: 24)).fontWeight(.medium)
                Spacer()
                Button(action: {
                    self.store.changeFavorite(for: self.package)
                }) {
                    Image(systemName: self.package.isFavorite ? "star.fill" : "star")
                        .frame(width: 30, height: 30, alignment: .center)
                        .foregroundColor(Color.yellow)
                }.buttonStyle(PlainButtonStyle())
            }.padding(.vertical, 8)
            HStack(){
                Text("("+self.package.subscriptionType.value+")").fontWeight(.heavy)
                Spacer()
            }
            .padding(.horizontal, 5)
            HStack{
                Text(self.package.desc).fontWeight(.ultraLight).multilineTextAlignment(.center)
                Spacer()
            }
            .padding(.all, 10)
            HStack(spacing: 10){
                Spacer()
                VStack(){
                    Text(self.package.tariff.data).font(.title)
                    Text("MB").fontWeight(.light)
                }
                VStack(){
                    Text(self.package.tariff.talk).font(.title)
                    Text("DK").fontWeight(.light)
                }
                VStack(){
                    Text(self.package.tariff.sms).font(.title)
                    Text("SMS").fontWeight(.light)
                }
                Spacer()
            }
            HStack{
                Text(self.package.didUseBefore ? "Paketi daha önce kullandınız" : "Daha önce kullanmadınız").fontWeight(.ultraLight).font(.system(size: 10))
            }
            HStack(){
                Spacer()
                Text("₺"+String(self.package.price)).font(.largeTitle).fontWeight(.semibold)
            }
            .padding(20)
        }
    }
}
