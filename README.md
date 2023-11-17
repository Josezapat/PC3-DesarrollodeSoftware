# Práctica Calificada N°3

Integrantes:
- José Daniel Zapata Ancco / 20202230A
- Omar Baldomero Vite Allca / 20200479B
- 
***
# Introducción
Creamos la Base de Datos:
$ bin/rake db:migrate
![image](https://github.com/Daniel349167/PC3-DesarrollodeSoftware/assets/90808325/b1222a2f-76d0-44a3-85d5-d956ebbeea05)


- Pregunta 1: ¿Cómo decide Rails dónde y cómo crear la base de datos de desarrollo? 

 Rails utiliza los archivos en los subdirectorios db y config para configurar y migrar la base de datos de desarrollo. El archivo config/database.yml especifica la configuración de la base de datos. 

- Pregunta 2: ¿Qué tablas se crearon mediante las migraciones?  

Las migraciones pueden encontrarse en el directorio db/migrate y contienen instrucciones para crear o modificar tablas en la base de datos.  

- Pregunta 3: ¿Qué datos de semilla se insertaron y dónde se especificaron?  

Los datos de semilla se especifican en el archivo db/seeds.rb. Se puede examinar ese archivo para ver qué datos se insertaron. 

![image](https://github.com/Daniel349167/PC3-DesarrollodeSoftware/assets/90808325/f9b20770-2444-470f-b1b3-6cdd3a1d4c2c)

Ejecutamos rails server 

Y nos dirigimos a localhost 3000 

![image](https://github.com/Daniel349167/PC3-DesarrollodeSoftware/assets/90808325/a73f79ab-93f4-4d9f-8a57-9cd885e0de9f)

***
# Parte 1

Modificamos el archivo Movies_controller.rb
```ruby
class MoviesController < ApplicationController
  before_action :set_ratings
  before_action :set_ratings_to_show, only: [:index]

  def index
    @movies = Movie.all

    # Actualizar las películas según las clasificaciones seleccionadas
    @movies = @movies.where(rating: @ratings_to_show)
  end

  private

  def set_ratings
    # Cargar todas las clasificaciones disponibles
    @all_ratings = Movie.all_ratings
  end

  def set_ratings_to_show
    # Cargar las clasificaciones seleccionadas del parámetro o de la sesión
    @ratings_to_show = params[:ratings] || session[:ratings] || @all_ratings
    session[:ratings] = @ratings_to_show
  end
end

```

Modificamos la Vista (index.html.erb):
```erb
<%= form_tag movies_path, method: :get, id: 'ratings_form' do %>
  <% @all_ratings.each do |rating| %>
    <div class="form-check form-check-inline">
      <%= label_tag "ratings[#{rating}]", rating, class: 'form-check-label' %>
      <%= check_box_tag "ratings[#{rating}]", "1", @ratings_to_show.include?(rating), class: 'form-check-input' %>
    </div>
  <% end %>
  <%= submit_tag 'Refresh', id: 'ratings_submit', class: 'btn btn-primary' %>
<% end %>
```

Nos aseguramos que el archivo config/routes.rb tenga una ruta que apunte a movies#index cuando se haga clic en el botón "Refresh":

```ruby
Rails.application.routes.draw do
  # Otras rutas...

  resources :movies

  root 'movies#index'
end
```
Modificamos Movie.rb
```ruby
class Movie < ActiveRecord::Base
  def self.all_ratings
    # Lógica para obtener todas las clasificaciones posibles
    ['G', 'PG', 'PG-13', 'R']
  end

  def self.with_ratings(ratings)
    # Lógica para obtener películas con las clasificaciones especificadas
    where(rating: ratings)
  end
end
```

Ejecutamos Rails Server y obtenemos los resultados

![image](https://github.com/Daniel349167/PC3-DesarrollodeSoftware/assets/90808325/055d9938-8688-436c-b23f-e8f95540664b)

Podemos añadir una nueva película 

![image](https://github.com/Daniel349167/PC3-DesarrollodeSoftware/assets/90808325/3a881a42-aae3-4019-afa5-45fe46f14f9e)

La película ha sido añadida 

![image](https://github.com/Daniel349167/PC3-DesarrollodeSoftware/assets/90808325/8ad28af1-99a2-493a-8f27-e8b4aaab1346)

- Pregunta: ¿Por qué el controlador debe configurar un valor predeterminado para @ratings_to_show incluso si no se marca nada?

Configurar un valor predeterminado para @ratings_to_show garantiza un comportamiento predecible y evita posibles problemas al manipular la colección de clasificaciones en la vista.

# Más sugerencias

Ahora modificamos el archivo movie.rb
```ruby
class Movie < ActiveRecord::Base
  def self.all_ratings
    # Lógica para obtener todas las clasificaciones posibles
    ['G', 'PG', 'PG-13', 'R']
  end

  def self.with_ratings(ratings_list)
    return all if ratings_list.nil? || ratings_list.empty?

    where(rating: ratings_list)
  end
end
```
En el método with_ratings, se agregó una verificación adicional para manejar el caso en que ratings_list es nil o está vacío. En este caso, se devuelven todas las películas.

Utilizaremos el método with_ratings en el controlador:

```ruby
def index
  @movies = Movie.with_ratings(@selected_ratings)
end
```
Ahora, @movies contendrá solo las películas que coinciden con las clasificaciones seleccionadas.

Por último subimos los cambios hechos a neustra rama: Josezapat:
![image](https://github.com/Daniel349167/PC3-DesarrollodeSoftware/assets/90808325/1fa5f383-2dd5-42d5-9353-73852cb87f50)

***
# Parte 2
***
# Parte 3

....
..
..
..
..
