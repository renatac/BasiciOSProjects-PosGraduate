//
//  UserPedidos.swift
//  BibliotecaCESARSchool
//
//  Created by RENATA on 11/04/21.
//

import Foundation

struct Pedido : Equatable {
    var livro: Livro
    var dataDeEmprestimo: Date
}

class User {
    static var shared = User()
    private init() {}

    var pedidos: [Pedido] = []
}
