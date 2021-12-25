//
//  AccountCreation.swift
//  HWChat
//
//  Created by HyunWook on 2020/04/01.
//  Copyright © 2020 HyunWook. All rights reserved.
//

import SwiftUI
import Firebase

struct AccountCreation : View {
    
    @Binding var show : Bool
    @State var name = ""
    @State var about = ""
    @State var picker = false
    @State var loading = false
    @State var imagedata : Data = .init(count: 0)
    @State var alert = false
    @State var value : CGFloat = 0

    var body : some View{
        
        VStack(alignment: .leading, spacing: 15){
            
            Text("멋져요!!! 계정을 만들어요").font(.title)
            
            HStack{
                
                Spacer()
                
                Button(action: {
                    
                    self.picker.toggle()
                    
                }) {
                    
                    if self.imagedata.count == 0{
                        
                       Image(systemName: "person.crop.circle.badge.plus").resizable().frame(width: 90, height: 70).foregroundColor(.gray)
                    }
                    else{
                        
                        Image(uiImage: UIImage(data: self.imagedata)!).resizable().renderingMode(.original).frame(width: 90, height: 90).clipShape(Circle())
                    }
                }
                
                Spacer()
            }
            .padding(.vertical, 15)
            
            Text("이름을 입력하세요")
                .font(.body)
                .foregroundColor(.gray)
                .padding(.top, 12)

            TextField("이름", text: self.$name)
                    .keyboardType(.default)
                    .padding()
                    .background(Color("Color"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.top, 15)
            
            Text("나의 메세지")
                .font(.body)
                .foregroundColor(.gray)
                .padding(.top, 12)

            TextField("메세지", text: self.$about)
                    .keyboardType(.default)
                    .padding()
                    .background(Color("Color"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.top, 15)
            
            if self.loading{
                
                HStack{
                    
                    Spacer()
                    
                    Indicator()
                    
                    Spacer()
                }
            }
                
            else{
                
                Button(action: {
                    
                    if self.name != "" && self.about != "" && self.imagedata.count != 0{
                        
                        self.loading.toggle()
                        CreateUser(name: self.name, about: self.about, imagedata: self.imagedata) { (status) in
                            
                            if status{
                                
                                self.show.toggle()
                            }
                        }
                    }
                    else{
                        
                        self.alert.toggle()
                    }
                    
                    
                }) {
                    

                Text("Create").frame(width: UIScreen.main.bounds.width - 30,height: 50)
                         
                }.foregroundColor(.white)
                .background(Color("bg"))
                .cornerRadius(10)
                
            }
            
        }
        .padding()
        .offset(y: -self.value)
        .animation(.spring())
        .onAppear {
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (noti) in
                self.value = 130
            }
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (noti) in
                self.value = 0
            }
        }
        .sheet(isPresented: self.$picker, content: {
            
            ImagePicker(picker: self.$picker, imagedata: self.$imagedata)
        })
        .alert(isPresented: self.$alert) {
            
            Alert(title: Text("메세지"), message: Text("내용을 입력하세요"), dismissButton: .default(Text("Ok")))
        }
    }
}
