//
//  ScndPage.swift
//  HWChat
//
//  Created by HyunWook on 2020/04/01.
//  Copyright © 2020 HyunWook. All rights reserved.
//

import SwiftUI
import Firebase

struct ScndPage : View {
    
    @State var code = ""
    @Binding var show : Bool
    @Binding var ID : String
    @State var msg = ""
    @State var alert = false
    @State var creation = false
    @State var loading = false
    @State var value : CGFloat = 0
    
    var body : some View{
        
        ZStack(alignment: .topLeading) {
            
            GeometryReader{_ in
                
                VStack(spacing: 20) {
                    
                    Image("pic")
                    
                    Text("인증 번호").font(.largeTitle).fontWeight(.heavy)
                    
                    Text("인증번호를 입력해주세요")
                        .font(.body)
                        .foregroundColor(.gray)
                        .padding(.top, 12)

                    TextField("코드", text: self.$code)
                            .keyboardType(.webSearch)
                            .padding()
                            .background(Color("Color"))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.top, 15)
                            .offset(y: -self.value)
                            .animation(.spring())
                            .onAppear {
                                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (noti) in
                                    self.value = 124
                                }
                                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (noti) in
                                    self.value = 0
                                }
                            }
                        
                    if self.loading{
                        
                        HStack{
                            
                            Spacer()
                            
                            Indicator()
                            
                            Spacer()
                        }
                    }
                    
                    else{
                        
                        Button(action: {
                             
                            self.loading.toggle()
                        
                            let credential =  PhoneAuthProvider.provider().credential(withVerificationID: self.ID, verificationCode: self.code)
                             
                             Auth.auth().signIn(with: credential) { (res, err) in
                                 
                                 if err != nil{
                                     
                                     self.msg = (err?.localizedDescription)!
                                     self.alert.toggle()
                                     self.loading.toggle()
                                     return
                                 }
                     
                                 checkUser { (exists, user,uid,pic) in
                                     
                                     if exists{
                                         
                                         UserDefaults.standard.set(true, forKey: "status")
                                         
                                         UserDefaults.standard.set(user, forKey: "UserName")
                                        
                                         UserDefaults.standard.set(uid, forKey: "UID")
                                        
                                         UserDefaults.standard.set(pic, forKey: "pic")
                                         
                                         NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                                     }
                                     
                                     else{
                                         
                                         self.loading.toggle()
                                         self.creation.toggle()
                                     }
                                 }
                                 
                                 
                             }
                             
                         }) {
                             
                             Text("인증").frame(width: UIScreen.main.bounds.width - 30,height: 50)
                             
                         }.foregroundColor(.white)
                         .background(Color("bg"))
                         .cornerRadius(10)
                    }
                    
                }
            }
            
            Button(action: {
                
                self.show.toggle()
                
            }) {
                
                Image(systemName: "chevron.left").font(.title)
                
            }.foregroundColor(Color("bg"))
            
        }
        .padding()
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $alert) {
                
            Alert(title: Text("에러"), message: Text(self.msg), dismissButton: .default(Text("Ok")))
        }
        .sheet(isPresented: self.$creation) {
            
            AccountCreation(show: self.$creation)
        }
    }
}


struct ScndPage_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello, World!")
    }
}
