//
//  ProfileTabView.swift
//  SwiftUiApp
//
//  Created by Дмитрий Никишов on 24.02.2022.
//

import SwiftUI

struct ProfileTabView: View {
    @State private var userName = ""
    @State private var password = ""
    
    @State var isUserNameFieldDisabled = false
    @State var isPasswordFieldDisabled = false
    
    @Binding var tabSelection: Int
    @Binding var isViewDisabled : Bool

    var body: some View {
        VStack {
            Spacer()
            Image("vk").resizable().aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
            
            Spacer()
            
            VStack {
                TextField("Email or phone", text : $userName)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                    .disabled(isUserNameFieldDisabled)
                
                SecureField("Password", text : $password)
                    .textFieldStyle(.roundedBorder)
                    .padding(/*@START_MENU_TOKEN@*/.horizontal/*@END_MENU_TOKEN@*/)
                    .disabled(isPasswordFieldDisabled)

                HStack {
                    Button(action: {
                        if !userName.isEmpty && !password.isEmpty {
                            closeKeyboard()
                            isUserNameFieldDisabled = true
                            isPasswordFieldDisabled = true
                            isViewDisabled = true
                            tabSelection = 1
                        }
                    }) {
                        Text("Log in")
                            .foregroundColor(self.isViewDisabled ? .gray : .white)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding(.top, 8)
                    .padding(.bottom, 8)
                    .background(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding(.horizontal)
            }
            
            Spacer()
        }.background(self.isViewDisabled ? .gray : .white)
    }
    
    func closeKeyboard() {
        UIApplication.shared.sendAction(
          #selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil
        )
      }
}

struct ProfileTabView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileTabView(tabSelection: .constant(1), isViewDisabled: .constant(false))
    }
}
