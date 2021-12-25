//
//  FirstPage.swift
//  HWChat
//
//  Created by HyunWook on 2020/04/01.
//  Copyright © 2020 HyunWook. All rights reserved.
//

import SwiftUI
import Firebase

struct FirstPage : View {
    
    @State var ccode = ""
    @State var no = ""
    @State var show = false
    @State var msg = ""
    @State var alert = false
    @State var ID = ""
    @State var value : CGFloat = 0

    
    var body : some View{
        
        VStack(spacing: 20){
            
            Image("pic")
            
            Text("H.W Chat").font(.largeTitle).fontWeight(.heavy) // 타이틀
            
            Text("계정을 확인하려면 번호를 입력하세요.")
                .multilineTextAlignment(.center)
                .font(.body)
                .foregroundColor(.gray)
                .padding(.top, 12)
            
            HStack{
                
                TextField("+1", text: $ccode)
                    .keyboardType(.default)
                    .frame(width: 45)
                    .padding()
                    .background(Color("Color"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                   
                
                TextField("번호", text: $no)
                    .keyboardType(.webSearch)
                    .padding()
                    .background(Color("Color"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
            }.padding(.top, 15)
            .offset(y: -self.value)
            .animation(.spring())
            .onAppear {
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (noti) in
                    self.value = 121
                }
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (noti) in
                    self.value = 0
                }
            }

            NavigationLink(destination: ScndPage(show: $show, ID: $ID), isActive: $show) {
                
                
                Button(action: {
                    
                    Auth.auth().settings?.isAppVerificationDisabledForTesting = true
                    PhoneAuthProvider.provider().verifyPhoneNumber("+"+self.ccode+self.no, uiDelegate: nil) { (ID, err) in
                        
                        if err != nil{
                            self.msg = (err?.localizedDescription)!
                            self.alert.toggle()
                            return
                        }
                        self.ID = ID!
                        self.show.toggle()
                    }
                }) {
                    
                    Text("입력").frame(width: UIScreen.main.bounds.width - 30,height: 50)
                    
                }.foregroundColor(.white)
                .background(Color("bg"))
                .cornerRadius(10)
            }

            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            
        }.padding()
        .alert(isPresented: $alert) {
            Alert(title: Text("에러"), message: Text(self.msg), dismissButton: .default(Text("Ok")))
        }
    }
}

struct FirstPage_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello, World!")
    }
}
