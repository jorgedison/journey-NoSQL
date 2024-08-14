#!/bin/bash

# Verificar si Elasticsearch está corriendo
echo "Verificando si Elasticsearch está en ejecución..."
curl -X GET "localhost:9200/_cat/health?v&pretty"

# Crear un índice
echo "Creando un índice llamado 'my_index'..."
curl -X PUT "localhost:9200/my_index?pretty"

# Verificar la creación del índice
echo "Verificando la creación del índice 'my_index'..."
curl -X GET "localhost:9200/_cat/indices?v&pretty"

# Añadir un documento al índice
echo "Añadiendo un documento al índice 'my_index'..."
curl -X POST "localhost:9200/my_index/_doc/1?pretty" -H 'Content-Type: application/json' -d'
{
  "name": "John Doe",
  "age": 30,
  "occupation": "Software Engineer"
}
'

# Buscar un documento en el índice
echo "Buscando el documento con ID 1 en el índice 'my_index'..."
curl -X GET "localhost:9200/my_index/_doc/1?pretty"

# Actualizar un documento existente
echo "Actualizando el documento con ID 1 en el índice 'my_index'..."
curl -X POST "localhost:9200/my_index/_update/1?pretty" -H 'Content-Type: application/json' -d'
{
  "doc": {
    "age": 31
  }
}
'

# Eliminar un documento del índice
echo "Eliminando el documento con ID 1 del índice 'my_index'..."
curl -X DELETE "localhost:9200/my_index/_doc/1?pretty"

# Eliminar el índice
echo "Eliminando el índice 'my_index'..."
curl -X DELETE "localhost:9200/my_index?pretty"

echo "Operaciones completadas."
