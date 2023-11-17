# Práctica Calificada N°3

Integrantes:
- José Daniel Zapata Ancco / 20202230A
- Omar Baldomero Vite Allca / 20200479B
- 
***
# Introducción
Creamos la Base de Datos:
$ bin/rake db:migrate


- Pregunta 1: ¿Cómo decide Rails dónde y cómo crear la base de datos de desarrollo? 

 Rails utiliza los archivos en los subdirectorios db y config para configurar y migrar la base de datos de desarrollo. El archivo config/database.yml especifica la configuración de la base de datos. 

- Pregunta 2: ¿Qué tablas se crearon mediante las migraciones?  

Las migraciones pueden encontrarse en el directorio db/migrate y contienen instrucciones para crear o modificar tablas en la base de datos.  

- Pregunta 3: ¿Qué datos de semilla se insertaron y dónde se especificaron?  

Los datos de semilla se especifican en el archivo db/seeds.rb. Se puede examinar ese archivo para ver qué datos se insertaron. 
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

Podemos añadir una nueva película 

La película ha sido añadida 


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


***
# Parte 2
***
# Parte 3

....
..
..
..
..
