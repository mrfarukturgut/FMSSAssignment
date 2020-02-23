//
//  ContentView.swift
//  FMSS
//
//  Created by Faruk Turgut on 19.02.2020.
//  Copyright © 2020 Faruk Turgut. All rights reserved.
//

import SwiftUI

struct PackagesView: View {
    
    //This was Observedobject, however I tried to seperate the constructor of the row view. To be able to that I changed this to environment object. However there was an runtime error -which I would solve in an actual project and seperate the constructor to another structure-   when I tried the code at the lines 25-27. This works fine right now so I am not changing it.
    @EnvironmentObject var store: PackagesViewModel
    @State var showingSort: Bool = false
    @State var showingFilter: Bool = false
    @State var fromPrice: Int = 0
    @State var toPrice: Int = 200
    private let navigationItemSize: CGFloat = 25
    
    var body: some View {
        
        NavigationView {
            List(self.store.filteredPackages.indices, id:\.self) { (idx) in
//                PackageRow(package: self.$store.filteredPackages[idx], store: self._store)
//                    .onReceive(self.store.objectWillChange) { (_) in
//                        self.store.objectWillChange.send()
//                }
                self.row(self.$store.filteredPackages[idx])
            }
            .navigationBarTitle("Paketler")
            .navigationBarItems(trailing:
                HStack{
                    Button(action: {
                        self.showingSort.toggle()
                    }) {
                        Image(systemName: "arrow.up.arrow.down.circle.fill")
                            .resizable()
                            .frame(width: self.navigationItemSize, height: self.navigationItemSize)
                    }.actionSheet(isPresented: self.$showingSort) {
                        ActionSheet(title: Text("Sırala"), message: Text("Paketleri sıralamak istediğiniz tarife içeriğini seçiniz. Şu anki sıralama ölçütü: \(self.store.currentSortOption.turkish)"), buttons: [
                            .default(Text("Veri"), action: {
                                self.store.currentSortOption = .data
                            }),
                            .default(Text("Konuşma"), action: {
                                self.store.currentSortOption = .talk
                            }),
                            .default(Text("SMS"), action: {
                                self.store.currentSortOption = .sms
                            }),
                            .cancel(Text("İptal"))
                        ])
                    }
                    Button(action: {
                        self.showingFilter.toggle()
                    }) {
                        Image(systemName: "line.horizontal.3.decrease.circle.fill")
                            .resizable()
                            .frame(width: self.navigationItemSize, height: self.navigationItemSize)
                    }.sheet(isPresented: self.$showingFilter) {
                        Form{
                            Section(header: Text("Keyword")) {
                                TextField("Search", text: self.$store.searchKeyword)
                            }
                            Section(header: Text("Price")) {
                                Stepper("Price from \(self.fromPrice)", value: self.$fromPrice, in: 0...self.toPrice, step: 5) { (_) in
                                    self.store.currentFilterOptions.byPrice = .byPrice(from: Float(self.fromPrice), to: Float(self.toPrice))
                                }
                                Stepper("Price to \(self.toPrice)", value: self.$toPrice, in: self.fromPrice...200, step: 5) { (_) in
                                    self.store.currentFilterOptions.byPrice = .byPrice(from: Float(self.fromPrice), to: Float(self.toPrice))
                                }
                            }
                        }
                        .edgesIgnoringSafeArea(.bottom)
                    }.onDisappear {
                        print("disappeared")
                    }
                })
        }
    }
}

extension PackagesView {

    //Constructs the view of each row in the list using data from binded package value.
    private func row(_ package: Binding<PackageList.Package>) -> some View {
           VStack {
               HStack{
                   Text(package.wrappedValue.name).font(.system(size: 24)).fontWeight(.medium)
                   Spacer()
                   Button(action: {
                       self.store.changeFavorite(for: package.wrappedValue)
                   }) {
                       Image(systemName: package.wrappedValue.isFavorite ? "star.fill" : "star")
                           .frame(width: 30, height: 30, alignment: .center)
                           .foregroundColor(Color.yellow)
                   }.buttonStyle(PlainButtonStyle())
               }.padding(.vertical, 8)
               HStack(){
                   Text("("+package.wrappedValue.subscriptionType.value+")").fontWeight(.heavy)
                   Spacer()
               }
               .padding(.horizontal, 5)
               HStack{
                   Text(package.wrappedValue.desc).fontWeight(.ultraLight).multilineTextAlignment(.center)
                   Spacer()
               }
               .padding(.all, 10)
               HStack(spacing: 10){
                   Spacer()
                   VStack(){
                       Text(package.wrappedValue.tariff.data).font(.title)
                       Text("MB").fontWeight(.light)
                   }
                   VStack(){
                       Text(package.wrappedValue.tariff.talk).font(.title)
                       Text("DK").fontWeight(.light)
                   }
                   VStack(){
                       Text(package.wrappedValue.tariff.sms).font(.title)
                       Text("SMS").fontWeight(.light)
                   }
                   Spacer()
               }
               HStack{
                   Text(package.wrappedValue.didUseBefore ? "Paketi daha önce kullandınız" : "Daha önce kullanmadınız").fontWeight(.ultraLight).font(.system(size: 10))
               }
               HStack(){
                   Spacer()
                   Text("₺"+String(package.wrappedValue.price)).font(.largeTitle).fontWeight(.semibold)
               }
               .padding(20)
        }
    }
}

struct PackagesView_Previews: PreviewProvider {
    static var previews: some View {
        PackagesView().environmentObject(PackagesViewModel())
    }
}

