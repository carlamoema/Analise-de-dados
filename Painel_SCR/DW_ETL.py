# Importando as bibliotecas que serão utilizadas para o processo de ETL
import pandas as pd
import glob as gl
from random import randint


## Criando a função que lê todos os arquivos .csv referente a 2023, gravados no diretório Dataset

def read_code(caminho_dataset):
     """Esta função recebe como parâmetro o caminho dos arquivos no formato '*.csv' lê todos os arquivos.csv 
        da pasta que contém os dados correspondentes a cada database e concatena em um só dataframe.
        1- Cria uma lista com os nomes dos arquivos do dataset (foi mantido um arquivo com a amostra dos meses janeiro a maio de 2023 devido ao limite de armazenamento do GitHub).
        2- Cria uma lista vazia para armazenar os dataframes.
        3- Usa uma estrutura de repetição para ler cada arquivo e armazenar na lista dfs, importando apenas as colunas que serão usadas.
        4- Concatena os dataframes em um só, o comando concat precisa receber com parâmetro a lista de dfs
     """
     arquivos = gl.glob(caminho_dataset, recursive=True)
     dfs=[]
     for arquivo in arquivos:
          df = pd.read_csv(arquivo, sep=';', 
                                    encoding='utf-8', 
                                    thousands='.', 
                                    decimal=',')
          dfs.append(df)
     df= pd.concat(dfs, ignore_index=True)
     return df


## Criando a função que limpa espaços vazios e strings redundantes de algumas colunas

def clean_code(df):    
     """Esta função realiza a limpeza dos dados do dataframe:
     1- Extrai os espaços vazios da coluna 'cliente'
     2- Extrai os espaços vazios da coluna 'uf'
     3- Extrai a string PF - da coluna ocupacao 
     4- Extrai a string PJ - da coluna cnae_secao
     5- Extrai a string PJ - da coluna cnae_subclasse
     6- Extrai a string PF - da coluna porte
     7- Extrai a string PJ - da coluna porte
     8- Extrai a string PF - da coluna modalidade
     9- Extrai a string PJ - da coluna modalidade
     10 - Exclui as linhas que possuem valores NaN na coluna número de operações
     """
     df.loc[:, 'cliente']= df.loc[:, 'cliente'].str.strip()
     df.loc[:, 'uf']= df.loc[:, 'uf'].str.strip()
     df.loc[:, 'ocupacao']= df.loc[:, 'ocupacao'].str.strip('PF - ')
     df.loc[:, 'cnae_secao']= df.loc[:, 'cnae_secao'].str.strip('PJ - ')
     df.loc[:, 'cnae_subclasse']= df.loc[:, 'cnae_subclasse'].str.strip('PJ - ')
     df.loc[:, 'porte']= df.loc[:, 'porte'].str.strip('PF - ')
     df.loc[:, 'porte']= df.loc[:, 'porte'].str.strip('J - ')
     df.loc[:, 'modalidade']= df.loc[:, 'modalidade'].str.strip('PF - ')
     df.loc[:, 'modalidade']= df.loc[:, 'modalidade'].str.strip('PJ - ')
     df = df.dropna(subset=['numero_de_operacoes'])
     return df


#### Criando a função que ajusta os tipos de dados de string para numérico

def change_code(df):
     """ 
     Esta função ajusta os tipo de dados de acordo com a informação contida nele
     1 - Alterando a coluna data-base para tipo datetime         
     2 - Ajustando as colunas 'ativo_problematico' e 'carteira_inadimplida_arrastada' para tipo float
     3 - Ajustando a Coluna Ocupacao para os cliente PJ (substituindo pelos dados da coluna cnae_secao - Atividade principal)
     4 - Usando random pra atribuir um número entre 1 e 15 para número de operações (quando são uma string <=15)    
     5 - Ajusta o tipo de dados de string (object) para inteiro na coluna numero de operacoes
     6 - Removendo ; da coluna cnae_secao
     """
     df['data_base'] = pd.to_datetime(df['data_base']) 
     df['carteira_inadimplida_arrastada']=df['carteira_inadimplida_arrastada'].astype(float, copy=False)
     df.loc[df['numero_de_operacoes'] == '<= 15', 'numero_de_operacoes'] = (df.loc[df['numero_de_operacoes'] == '<= 15', 'numero_de_operacoes'].apply(lambda x: randint(1, 15) if x.strip() == '<= 15' else x))
     df['numero_de_operacoes'] = df['numero_de_operacoes'].astype(int)
     df['cnae_secao']= df['cnae_secao'].str.replace(';',',')
     return df



# Chamando a função de leitura dos dados 
caminho_dataset= './Dataset/*.csv'
df = read_code(caminho_dataset)

# Chamando a função de limpeza dos dados
df= clean_code(df)


# Chamando a função que ajusta os tipos de dados
df= change_code(df)


#------------------------- Gerando um csv com os tipos de cliente para popular a dimcliente----------#
cliente=df.loc[:, 'cliente'].unique()
df_cliente= pd.DataFrame(cliente, columns=['cliente'])
df_cliente.to_csv(index=False, path_or_buf='./Dimensoes/cliente.csv', 
                 encoding='utf-8')



#------------------------- Gerando um csv com os tipos de ocupacao para popular a dimocupacao----------#
ocupacao=df.loc[:, 'ocupacao'].unique()
df_ocupacao= pd.DataFrame(ocupacao, columns=['ocupacao'])
df_ocupacao.to_csv(index=False, path_or_buf='./Dimensoes/ocupacao.csv', 
                 encoding='utf-8')


#------------------------- Gerando um csv com os tipos de cnae para popular a dimcnae----------#
cnae=df.loc[:, 'cnae_secao'].unique()
df_cnae= pd.DataFrame(cnae, columns=['secao'])
df_cnae.to_csv(index=False, path_or_buf='./Dimensoes/cnae.csv', encoding='utf-8')


#------------------------- Gerando um csv com os tipos de indexador para popular a dimindexador----------#

indexador=df.loc[:, 'indexador'].unique()
df_indexador= pd.DataFrame(indexador, columns=['indexador'])
df_indexador.to_csv(index=False, path_or_buf='./Dimensoes/indexador.csv', 
                 encoding='utf-8')

#------------------------- Gerando um csv com os tipos de modalidade para popular a dimmodalidade----------#

modalidade=df.loc[:, 'modalidade'].unique()
df_modalidade= pd.DataFrame(modalidade, columns=['modalidade'])
df_modalidade.to_csv(index=False, path_or_buf='./Dimensoes/modalidade.csv', 
                 encoding='utf-8')


#------------------------- Gerando um csv com os tipos de origem para popular a dimorigem----------#

origem=df.loc[:, 'origem'].unique()
df_origem= pd.DataFrame(origem, columns=['origem'])
df_origem.to_csv(index=False, path_or_buf='./Dimensoes/origem.csv', 
                 encoding='utf-8')


#------------------------- Gerando um csv com os tipos de porte para popular a dimporte----------#

porte=df.loc[:, 'porte'].unique()
df_porte= pd.DataFrame(porte, columns=['porte'])
df_porte.to_csv(index=False, path_or_buf='./Dimensoes/porte.csv', 
                 encoding='utf-8')



#------------------------- Gerando um csv com os tipos de sr para popular a dimsr----------#
df_sr = df.dropna(subset=['sr'])
sr=df_sr.loc[:,'sr'].unique()
df_sr= pd.DataFrame(sr, columns=['sr'])
df_sr.to_csv(index=False, path_or_buf='./Dimensoes/sr.csv', 
                 encoding='utf-8')


#------------------------- Gerando um csv com os tipos de tcb para popular a dimtcb----------#

tcb=df.loc[:, 'tcb'].unique()
df_tcb= pd.DataFrame(tcb, columns=['tcb'])
df_tcb.to_csv(index=False, path_or_buf='./Dimensoes/tcb.csv', 
                 encoding='utf-8')


#------------------------- Gerando um csv com os tipos de uf para popular a dimuf----------#

uf=df.loc[:, 'uf'].unique()
df_uf= pd.DataFrame(uf, columns=['uf'])
df_uf.to_csv(index=False, path_or_buf='./Dimensoes/uf.csv', 
                 encoding='utf-8')


#------------------------- Exportando o arquivo csv -------------------------------------------------------#
csv= df.to_csv(index=False, 
               path_or_buf='./Dataset/tabelafato/tabelaoriginal.csv', 
               sep=';', 
               encoding='utf-8', 
               decimal=',')