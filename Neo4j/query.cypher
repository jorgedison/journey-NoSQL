// ------------------------------------------------
// ------------
// NODOS      -
// ------------

// Todos los nodos 

MATCH (n) RETURN n 

// Nodos con label 

MATCH (m:Movie) RETURN m.title

// Nodos relacionados sin dirección - todos los nodos

MATCH (director {name: ''})--(movie) RETURN movie

// Match con etiquetas

MATCH (:Person {name: ''})--(movie:Movie) RETURN movie.title

// ------------
// RELACIONES -
// ------------

// Dirección la relación cualquier nodo

MATCH (:Person { name: '' })-->(movie)
RETURN movie.title

// Relación como variable 

MATCH (:Person { name: '' })-[r]->(movie)
RETURN type(r)

// MATCH con tipo de relación 

MATCH (wallstreet:Movie { title: '' })<-[:ACTED_IN]-(actor)
RETURN actor.name

// Múltiples realaciones 

MATCH (wallstreet { title: '' })<-[:ACTED_IN|:DIRECTED]-(person)
RETURN person.name

// Role de la Relación 

MATCH (wallstreet { title: '' })<-[r:ACTED_IN]-(actor)
RETURN r.role

// Multiples relaciones con multiples direcciones 

MATCH (charlie { name: '' })-[:ACTED_IN]->(movie)<-[:DIRECTED]-(director)
RETURN movie.title, director.name


// variable lenght Relationships

MATCH (charlie { name: '' })-[:ACTED_IN|DIRECTED*2]-(person:Person)
RETURN person.name

// ------------
// WHERE      -
// ------------

// String 
MATCH (p:Person) WHERE p.name = 'Joel Silver' RETURN p
// number
MATCH (p:Person) WHERE p.born = 1950 RETURN p

// Mayor igual 
MATCH (p:Person) WHERE p.born > 1960 RETURN p.name, p.born

// WHERE relationship - Peronas que hayan hecho review con rating mayor a X
MATCH (n:Person)-[r:REVIEWED]->(m)
WHERE  r.rating > 70
RETURN n.name, r.rating, m.title

// ------------
// EXISTS     -
// ------------

// Las peronas que tienen una relacion con pelicula
// donde la relación tiene un rating
MATCH (p:Person)-[r]->(m:Movie)
WHERE EXISTS (r.rating)
RETURN p,n

// STARTS WITH 
MATCH (n:Person)
WHERE n.name STARTS WITH 'L'
RETURN n.name

// ENDS WITH 
MATCH (n:Person)
WHERE n.name ENDS WITH 'er'
RETURN n.name

// CONTAINS
MATCH (n:Person)
WHERE n.name CONTAINS 'er'
RETURN n.name, n.age

// -------------
// COMPARADORES-      
// -------------

// Personas que nacieron después del 1970
MATCH (p:Person)
WHERE p.born > 1970 
RETURN p

// Las que nacieron exactamente en 
MATCH (p:Person)
WHERE p.born = 1950
RETURN p

// Personas que han hecho reviews a peliculas
// que tienen un rating mayor a 

MATCH (p:Person)-[r:REVIEWED]->(m:Movie) 
WHERE r.rating >= 70
RETURN p,r,m

// ahora Agregar si aparte la pelicula 
// salio despues del 200
MATCH (p:Person)-[r:REVIEWED]->(m:Movie) 
WHERE r.rating >= 70 AND m.released > 2000
RETURN p,r,m

// IS NULL para saber quienes tienen alguna
// propiedad en null 

MATCH (p:Person)
WHERE p.born IS NULL
RETURN p

// práctica usar el IS NOT NULL

// ----------------------------
// OPERADORES LÓGICOS         -      
// ----------------------------


// Las peliculas que se publicaron después de 1990 Y
// empiecen con 'The'
MATCH (m:Movie)
WHERE m.released > 1990 AND m.title STARTS WITH 'The'
RETURN m.title, m.released

// Peliculas que empiecen con una u otro prefijo
MATCH (m:Movie)
WHERE m.title STARTS WITH 'A' OR m.title STARTS WITH 'The'
RETURN m.title, m.released

//NOT 

MATCH (m:Movie)<-[r]-(p:Person)
WHERE NOT m.released = 1997 AND NOT m.title STARTS WITH 'A' AND NOT m.title STARTS WITH 'The'
RETURN m.title, m.released

// Peliculas que tengan un rating mayor a 60
// xor que empiecen con A o THE 
// Por lo que no estarán las The matrix ya que 
// Debe o tener The y excluir las condiciones del XOR
// NUNCA ambos a la vez
MATCH (m:Movie)<-[r]-(p:Person)
WHERE m.title STARTS WITH 'The' 
XOR (m.released = 1999 OR m.released = 2003)
RETURN m.title, m.released


// CON DISTINCT 

MATCH (m:Movie)<-[r]-(p:Person)
WHERE m.title STARTS WITH 'The' 
XOR (m.released = 1999 OR m.released = 2003)
RETURN DISTINCT m.title, m.released

// estamos parchando el query lo que debemos hacer 
// es ver por qué pasa eso 
// vamos a imprimir más

MATCH (m:Movie)<-[r]-(p:Person)
WHERE m.title STARTS WITH 'The' 
XOR (m.released = 1999 OR m.released = 2003)
RETURN m.title, m.released, type(r) ,p.name

// No necesitamos a la relación ni Person
// Removemos esa relación para que Neo4j no 
// busque esas relaciones y no nos duplique los resultados
MATCH (m:Movie)
WHERE m.title STARTS WITH 'The' 
XOR (m.released = 1999 OR m.released = 2003)
RETURN m.title, m.released


// ----------------------------
// REGEX                      -      
// ----------------------------

// Peliculas que tienen en el titulo
// 'ix' con cualquier caracrer antes o después
MATCH (m:Movie) 
WHERE m.title =~'.*ix.*'
RETURN m.title


//escapar  , o * 
// revisamos aquellas peliculas donde su resumen contenga
// U.S.
MATCH (m:Movie)
WHERE m.tagline =~ '.*U\\.S\\..*'
RETURN m.title, m.tagline

// insensitive (?i)
// Buscamos las peronas que su nombre contenga un patrón
MATCH (p:Person)
WHERE p.name =~ '(?i).*ER.*'
RETURN p.name, p.age


// ----------------------------
// ORDER BY                   -      
// ----------------------------

// * Se ordenan los resultados no nodos ni relaciones
// * El performance de order by se puede ver afectado por
//   los index existentes de los nodo, evita Sort algoritmo

// Ordenando opor nombre ascendente por default
MATCH (p:Person)
RETURN p.name, p.born
ORDER BY p.name 

// DESC[ENDING] descendente
MATCH (p:Person)
RETURN p.name, p.born
ORDER BY p.name DESC

// null ? 
// En orden descentende los valores null vienen la final de los resultados
// En orden ascendente los null vienen al principio

MATCH (p:Person)
RETURN  p.born, p.name
ORDER BY p.born 

// Ordenando por multiples valores
// Siempre se ordena por el primer criterio
// después para valores iguales por la segunda

MATCH (p:Person)
RETURN p.name, p.born
ORDER BY p.born, p.name


// SKIP - Define desde que row empezar a incluir en la salida

// nos saltamos los primeros tres resultados
MATCH (p:Person)
RETURN p.name, p.born
ORDER BY p.name 
SKIP 3

// Supongamos que queremos un subconjunto
// podemos limitar con LIMIT

MATCH (p:Person)
RETURN p.name, p.born
ORDER BY p.name 
SKIP 10
LIMIT 10

// SKIP y LIMIT acepta cualquier 
// expresión matemática que
// nos de un entero

MATCH (p:Person)
RETURN p.name, p.born
ORDER BY p.name 
SKIP toInteger(3*rand())+ 1
LIMIT toInteger(8*rand())+ 2

// AS and functions
// renombra en nuestros resultados p.name
// no paracerá como p.name sino como Name

MATCH (p:Person)
RETURN p.name AS Name, p.born AS Birth_Year
ORDER BY p.name 
SKIP toInteger(3*rand())+ 1
LIMIT toInteger(3*rand())+ 1

// ----------------------------
// FUNCTIONS                  -      
// ----------------------------

// count, número de valores o rows

// todos los nodos
MATCH (n)
RETURN count(n)

// todas las relaciones

MATCH ()-->() RETURN count(*);

// MIN y MAX

MATCH (m:Movie)
RETURN min(m.released) as MIN_YEAR_RELEASE, max(m.released) AS MAX_YEAR_RELEASE

// AVG, SUM, RATING

// Primero veamos los registros 
MATCH (m:Movie)<-[r:REVIEWED]-(p:Person)
RETURN m.title, r.rating, p.name

// Promedio, número de resultados, suma de todo
MATCH (m:Movie)<-[r:REVIEWED]-(p:Person)
RETURN avg(r.rating) AS RATING_AVERAGE, count(r), sum(r.rating)


// What kind of nodes exist
// Sample some nodes, reporting on property and relationship counts per node.
MATCH (n)
RETURN DISTINCT labels(n),
count(*) AS SampleSize,
avg(size(keys(n))) as Avg_PropertyCount,
min(size(keys(n))) as Min_PropertyCount,
max(size(keys(n))) as Max_PropertyCount,
avg(size( (n)-[]-() ) ) as Avg_RelationshipCount,
min(size( (n)-[]-() ) ) as Min_RelationshipCount,
max(size( (n)-[]-() ) ) as Max_RelationshipCount


// ----------------------------
// FUNCTIONS STRING           -      
// ----------------------------

// toLower

MATCH (m:Movie)
RETURN m.title, toLower(m.tagline)

// toUpper
MATCH (m:Movie)
RETURN toUpper(m.title), m.tagline

// replace()

MATCH (m:Movie)
RETURN m.title, replace(m.tagline, 'Welcome', 'Good Bye')

MATCH (m:Movie)
RETURN m.title, replace(m.tagline, 'U.S.', 'SOME COUNTRY')

// ----------------------------
// MATH FUNCTIONS             -      
// ----------------------------

MATCH (n)
RETURN DISTINCT labels(n),
count(*) AS SampleSize,
ceil(avg(size(keys(n)))) as Avg_PropertyCount_Ceil,
avg(size(keys(n))) as Avg_PropertyCount,
floor(avg(size( (n)-[]-() ) )) as Avg_RelationshipCount_Floor,
avg(size( (n)-[]-() ) ) as Avg_RelationshipCount

MATCH (p:Person)
RETURN p.name, p.born
ORDER BY p.name 
SKIP toInteger(3*rand())+ 1
LIMIT toInteger(8*rand())+ 2


// ----------------------------
// CREATION                   -      
// ----------------------------

CREATE (matrix:Movie { title:"The Matrix",released:1997 })
CREATE (cloudAtlas:Movie { title:"Cloud Atlas",released:2012 })
CREATE (forrestGump:Movie { title:"Forrest Gump",released:1994 })
CREATE (keanu:Person { name:"Keanu Reeves"})
CREATE (robert:Person { name:"Robert Zemeckis", born:1951 })
CREATE (tom:Person { name:"Tom Hanks", born:1956 })
CREATE (tom)-[:ACTED_IN { roles: ["Forrest"]}]->(forrestGump)
CREATE (tom)-[:ACTED_IN { roles: ['Zachry']}]->(cloudAtlas)
CREATE (robert)-[:DIRECTED]->(forrestGump)


// creando index

// Usar un index nos da un punto transversal
// de nuestro grafo
// para verlos CALL db.indexes

CREATE INDEX ON :Actor(name)

// cuando queremos que un campo sea único
// para verlas CALL db.constraints

CREATE CONSTRAINT ON (movie:Movie) ASSERT movie.title IS UNIQUE

CREATE (n)

CREATE (n),(m)

// Nodo con etiqueta
CREATE (c:Crime)

// retornando atributos
CREATE (p { name: 'Andy' })
RETURN p.name

// Creando con propiedades
//1
CREATE (n:Person { name: 'Andy', surname: 'Hamilton', nhs_no:"117-66-8129"})
//2
CREATE (c:Crime { 
    id:"43d-3dd3-d323-ded",
    date:"17/08/2017", 
    type:"Vehicle crime", 
    last_outcome:"Investigation complete; no suspect identified"}) 
    RETURN c

CREATE (andy:Person{name:"Andy"}),(jhon:Person{name:"Jhon"})
RETURN andy, jhon

// Relacionar dos nodos
MATCH (andy:Person),(jhony:Person)
WHERE id(andy)= 4 AND id(jhony)= 5
CREATE (andy)-[r:KNOWS_LW]->(jhony)
RETURN type(r)

CREATE (pc:PhoneCall{
    call_time: "14:48",
    call_date: "12/08/2017",
    call_type: "SMS",
    call_duration: "24"
}) return pc

CREATE (p:Phone{
    phoneNumber:"6(345)454323"
}) RETURN p

// Creando con propiedades de relaciones
MATCH (pc:PhoneCall),(p:Phone)
WHERE id(pc)= 7 AND id(p)= 8
CREATE (pc)-[r:CALLER{
    secureLine: false,
    company: "Phones Inc"
}]->(p) RETURN type(r)

// FULL 
// todas las partes del patrón que no estan
// en el scope, son creadas 
CREATE p =(
c:Crime { type:'Burglary', date: "24/08/2017"})
-[:OCCURRED_AT]->(l:Location{address:"19 Gladstone Road"})
-[:HAS_POSTCODE]->(pc:PostCode { postCode: 'OL9 9TH' })
-[:POST_IN_AREA]->(a:Area{areaCode: "WN2"})
-[:LOCATION_IN_AREA]->(l)
RETURN p

// DELETE 
// The DELETE clause is used to delete nodes, relationships or paths.

// No borra grandes cantidades de información, 
// pero borra pequeños ejemplos de información
MATCH (n)
DETACH DELETE n

// Borrar un nodo
MATCH (n:Person { name: 'UNKNOWN' })
DELETE n
// Borrar nodo con sus relaciones 
MATCH (n { name: 'Andy' })
DETACH DELETE n

// Borrando sólo relaciones 
// Borra todas las relaciones KNOWS
MATCH (n { name: 'Andy' })-[r:KNOWS]->()
DELETE r

// Encontrando algún nodo
MATCH (n) RETURN n LIMIT 30

// buscando sus relaciones por nhs_no
MATCH (p:Person)-->(f)
WHERE p.nhs_no = '791-62-3536'
RETURN p, f

// Borrando sus relación HAS_PHONE
MATCH (p:Person {nhs_no:'791-62-3536'})-[r:HAS_PHONE]-()
DELETE r

// todo con relaciones
MATCH (p:Person {nhs_no:'791-62-3536'})
DETACH DELETE p




// Who represents NY?
MATCH (s:State)<-[:REPRESENTS]-(l:Legislator)
WHERE s.code = "NY"
RETURN s,l

// representates de un estado con su partido
MATCH (s:State {code: "CA"})<-[:REPRESENTS]-(l:Legislator)
MATCH (l)-[r:IS_MEMBER_OF]->(p:Party)
RETURN s,l,p


// Let's limit our analysis to only Senators representing California:
MATCH (s:State {code: "CA"})<-[:REPRESENTS]-(l:Legislator)
MATCH (l)-[:ELECTED_TO]->(b:Body {type: "Senate"})
MATCH (l)-[:IS_MEMBER_OF]->(p:Party)
RETURN s,l,b,p

// Each legislator serves on one or more congressional committees.
// each committee has jurisdiction over bills of a given subject matter
// By serving on certain committees legislators can gain more influence
// over bills that fall in their committees' jurisdictions

MATCH (ca:State {code: "CA"})<-[:REPRESENTS]-(l:Legislator)
MATCH (l)-[:ELECTED_TO]->(senate:Body {type: "Senate"})
MATCH (l)-[:SERVES_ON]->(c:Committee)
RETURN l,c, ca


// SET -  can be used with a map — provided as a literal,
// a parameter, or a node or relationship — to set properties.
// Setting labels on a node is an idempotent operation
// — nothing will occur if an attempt is made to set a
//label on a node that already has that label.
// The query statistics will state whether any updates actually took place.



// SET propiedades y etiquetas

// Agregando una nueva propiedad
MATCH (l:Legislator) RETURN l LIMIT 1
MATCH (l:Legislator {bioguideID:"B000944"}) RETURN l
//1)
MATCH (l:Legislator {bioguideID:"B000944"})
SET l.email = 'brow@gmail.com'
RETURN l

//2)
MATCH (l:Legislator {bioguideID:"B000944"})
SET l.yearsExperience = "10"
RETURN l 

MATCH (l:Legislator {bioguideID:"B000944"})
SET l.yearsExperience = toInteger(l.yearsExperience)
RETURN l 

//3 many properties as MAP

MATCH (l:Legislator {bioguideID:"H001058"})
SET l.birthday= '1960-11-09',l.democratCount= 20 
RETURN l.bioguideID, l.birthday, l.democratCount

// 4 SET labels 
MATCH (b:Body {type:"House"})
SET b:LEGISLATIVE_INSTITUTION:OTHER
RETURN b.type, labels(b) AS labels

// MATCH (b:Body {type:"House"})
// REMOVE b:LEGISLATIVE_INSTITUTION
// RETURN b.type, labels(b) AS labels


// USING MAP with SET 

// Any properties in the map that are not on the
// node or relationship will be added.

//Any properties not in the map that are on
//the node or relationship will be left as is.

//Any properties that are in both the map and
//the node or relationship will be replaced in
//the node or relationship. However, if any
//property in the map is null, it will be removed from the node or relationship.

MATCH (s {title: "Grain"})
SET s += { title: "Grain UPDATED", summary: "blablablabal", years:2}
RETURN s

// = replace all properties 

// Remove all properties
MATCH (s {title: "Grain"})
SET s = {}
RETURN s


// REMOVE propiedades y etiquetas

MATCH (b:Bill {billID:"hr1136-114"})
REMOVE b.enacted:
RETURN b

// Si quiero remover todo usar SET = {}
MATCH (b:Body {type:"House"})
REMOVE b:LEGISLATIVE_INSTITUTION:OTHER
RETURN b

// CALL is used to evaluate a subquery which is a procedure
// The YIELD sub-clause is used to explicitly select which
// of the available result fields are returned as newly-bound
// variables from the procedure call to the user or for further
// processing by the remaining query.

MATCH (n:Legislator{bioguideID:"C000174"})-[rel:REPRESENTS]->(s:State)
CALL apoc.refactor.setType(rel, 'REPRESENTING')
YIELD input, output
RETURN input, output


// MERGE : MATCH an CREATE ?
// MERGE either matches existing nodes
// and binds them, or it creates new data and binds that

// Merge single node with a label
// Creation
MERGE (robert:Critic)
RETURN robert, labels(robert)


// Merge single node with properties
// Creation
MERGE (charlie { name: 'Charlie Sheen', age: 10 })
RETURN charlie

// MATCHING 

MERGE (michael:Person { name: 'Michael Douglas' })
RETURN michael.name, michael.bornIn


// Using matching for creation

MATCH (t:Team)
MERGE (i:Identity{name: substring(t.name,0,3)})
RETURN pre



// finding keanu
// And setting props on creation

MERGE (p:Person{name:"Andreia"})
ON CREATE SET p.VIP = true, p.creationDate = timestamp()
RETURN p


// With found ? 
MERGE (person:Person)
ON MATCH SET person.found = TRUE RETURN person.name, person.found


// MERGE Relationships 

MATCH (t:Team {name:"Equatorial Guinea"}), (i:Identity{name:"Equ"})
MERGE (t)-[r:HAS_INDENTITY]->(i)
RETURN t, type(r), i


// Multiple relatonships

MATCH (t:Team {name:"Nigeria"}), (i:Identity{name:"Nig"})
MERGE (to:Tournament{name:"México 2050"})-[p:PARTICIPATED_IN]->(t)-[r:HAS_INDENTITY]->(i)
RETURN t,i,p,to,r
