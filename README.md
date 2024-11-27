Descrição das Tabelas do Modelo de Banco de Dados restaurant
Este projeto foi desenvolvido para gerenciar informações relacionadas a pedidos em um ou mais restaurantes. O banco de dados inclui tabelas que registram detalhes sobre restaurantes, pedidos, itens do cardápio, taxas, e outros elementos essenciais para a operação.

Estrutura do Banco de Dados
Tabela restaurant
Armazena informações sobre os restaurantes, como nome, localização, e descrição.

Relacionamentos: Nenhum direto.
Campos principais:
restaurant_id: Identificador único do restaurante.
name: Nome do restaurante.
location: Localização do restaurante.
Tabela guestChecks
Registra os pedidos feitos pelos clientes, incluindo totais, número da mesa e detalhes sobre abertura e fechamento.

Relacionamentos:
1:N com restaurant (um restaurante pode ter vários pedidos).
Campos principais:
guest_check_id: Identificador único do pedido.
chk_num: Número do pedido.
clsd_flag: Indica se o pedido foi fechado.
Tabela taxTypes
Lista os tipos de taxas aplicáveis aos pedidos, como impostos e taxas de serviço.

Relacionamentos: Nenhum direto.
Campos principais:
tax_type_id: Identificador único do tipo de taxa.
tax_type_name: Nome do tipo de taxa.
Tabela taxes
Registra as taxas aplicadas a cada pedido, vinculando o pedido a um tipo de taxa.

Relacionamentos:
N:1 com guestChecks (um pedido pode ter múltiplas taxas).
N:1 com taxTypes (múltiplas taxas podem referir-se ao mesmo tipo).
Campos principais:
tax_num: Identificador único da taxa.
tax_rate: Taxa percentual aplicada.
Tabela menuItems
Armazena detalhes sobre os itens do cardápio, incluindo preços e impostos aplicáveis.

Relacionamentos: Referenciada por detailLines.
Campos principais:
menu_item_id: Identificador único do item.
incl_tax: Imposto incluído no preço do item.
Tabela detailLines
Armazena os detalhes de cada item incluído em um pedido.

Relacionamentos:
N:1 com guestChecks (um pedido pode ter múltiplos itens).
N:1 com menuItems (cada item está associado a um produto do cardápio).
Campos principais:
guest_check_line_item_id: Identificador único da linha de detalhe.
menu_item_id: Referência ao item do cardápio.
Scripts de Criação das Tabelas
O script SQL detalhado para a criação das tabelas e os relacionamentos foi fornecido no início deste repositório.

Dados de Exemplo
Inclui registros fictícios para testes, como:

Restaurantes (restaurant): "Restaurant A", "Restaurant B".
Pedidos (guestChecks): Pedidos com números e totais variados.
Itens do Cardápio (menuItems): Itens com impostos e preços definidos.
Taxas (taxes e taxTypes): Tipos de taxas e seus valores.
