# 📈 Monitor de Indicadores Econômicos

Um aplicativo desenvolvido em **Flutter** para visualização e análise de indicadores econômicos brasileiros em tempo real, consumindo dados oficiais do **Banco Central do Brasil**.

## 📱 Estrutura do Aplicativo

O aplicativo está dividido em 4 módulos principais:

1.  **Monitoramento em Tempo Real:** Listagem de indicadores via Firestore com atualização dinâmica do último valor via API do Banco Central (SGS/BCB).
2.  **Consulta por Período:** Interface de busca com validação de datas para recuperação de séries históricas personalizadas.
3.  **Análise Econômica:** * Visualização de dados através de gráficos de linha interativos (`fl_chart`).
    * Cálculo automático de métricas: Mínimo, Máximo, Média e Variação percentual do período selecionado.
4.  **Persistência de Análises:** Módulo para salvar resultados importantes no Firebase, permitindo a gestão (leitura e exclusão) de estudos econômicos prévios.

## 🧮 Lógica de Análise

Para cada consulta realizada, o sistema processa a lista de dados brutos da API para extrair:
- **Média Aritmética:** $\bar{x} = \frac{1}{n} \sum_{i=1}^{n} x_i$
- **Volatilidade:** Identificação de picos (Máximo) e vales (Mínimo).
- **Variação Acumulada:** Diferença percentual entre o valor inicial e final do período selecionado.

## 🛠️ Tecnologias Utilizadas

- [Flutter](https://flutter.dev/) - Framework UI.
- [Dart](https://dart.dev/) - Linguagem de programação.
- [Firebase Firestore](https://firebase.google.com/docs/firestore) - Banco de dados NoSQL para configuração dos indicadores.
- [HTTP](https://pub.dev/packages/http) - Consumo da API REST do Banco Central.
- [FL Chart](https://pub.dev/packages/fl_chart) - Renderização de gráficos técnicos.

## 📋 Pré-requisitos

Antes de começar, é necessário ter instalado:
- Flutter SDK (versão estável mais recente)
- Um editor de código (VS Code ou Android Studio)
- Um projeto configurado no [Firebase Console](https://console.firebase.google.com/)

## ⚙️ Configuração do Banco de Dados (Firestore)

Para que o app funcione corretamente, crie uma coleção chamada `indicadores` no Firestore com a seguinte estrutura:

| Campo | Tipo | Descrição |
| :--- | :--- | :--- |
| `nome` | String | Nome do indicador (ex: Taxa SELIC) |
| `codigo` | Number | Código da série no SGS/BCB (ex: 11) |

## 🔧 Como Rodar o Projeto

1. **Clone o repositório:**
   ```bash
   git clone [https://github.com/fermiwa/monitor_economico.git](https://github.com/fermiwa/monitor_economico.git)
