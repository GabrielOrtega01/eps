<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Página Principal del Cliente</title>
    <link rel="stylesheet" href="styles.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f0f0;
            margin: 0;
            padding: 0;
        }

        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }

        h1 {
            text-align: center;
            color: #333;
        }

        .options {
            display: flex;
            flex-direction: column;
            gap: 10px;
            margin-top: 20px;
        }

        .option {
            background-color: #fff;
            border: 1px solid #ccc;
            border-radius: 5px;
            padding: 10px;
        }

        .option a {
            text-decoration: none;
            color: #333;
        }

        .option a:hover {
            color: #007bff;
        }
/* Cambia el color del botón de salida de sesión */
.logout-btn {
    background-color: #007bff; /* Nuevo color de fondo (azul claro) */
    color: #fff; /* Color del texto */
    border: none; /* Sin borde */
    border-radius: 5px; /* Bordes redondeados */
    padding: 10px 20px; /* Espaciado interno */
    font-size: 16px; /* Tamaño de fuente */
    cursor: pointer; /* Cursor al pasar por encima */
}

.logout-btn:hover {
    background-color: #0056b3; /* Nuevo color de fondo al pasar por encima */
}


.logout-btn:focus {
    outline: none; /* Sin contorno al enfocar */
}

    </style>
</head>
<body>
    <div class="container">
        <%-- Obtener los datos del usuario desde la sesión --%>
        <% String tipoUsuario = (String) session.getAttribute("tipoUsuario"); %>
        <% String nombreUsuario = (String) session.getAttribute("nombreUsuario"); %>
        <% String apellidoUsuario = (String) session.getAttribute("apellidoUsuario"); %>

        <%-- Mostrar el saludo personalizado --%>
        <h1>Bienvenido, <%= tipoUsuario %> <%= nombreUsuario %> <%= apellidoUsuario %></h1>
        <div class="options">
            <div class="option">
                <a href="mostrar.jsp">Mostrar datos</a>
            </div>
            <div class="option">
                <a href="actualizar_datos.jsp">Actualizar Datos</a>
            </div>
            <div class="option">
                <a href="ingresar_cita_medico.jsp">Ingresar Cita con el Médico</a>
            </div>
            <div class="option">
                <a href="mostrar_cita_medico.jsp">Mostrar Cita con el Médico</a>
            </div>
            <div class="option">
                <a href="actualizar_cita_medico.jsp">Actualizar Cita con el Médico</a>
            </div>
            <div class="option">
                <a href="eliminar_cita_medico.jsp">Eliminar Cita con el Médico</a>
            </div>
<div class="option">
    <form action="logout.jsp" method="post">
        <button type="submit" class="logout-btn">Salir Sesión</button>
    </form>
</div>

        </div>
    </div>
    <footer class="bg-dark text-light text-center py-3" style="width: 100%; height: 100px;">
        <div class="container">
            <p>&copy; 2024 EPS Securitas. Todos los derechos reservados.</p>
        </div>
    </footer>
</body>
</html>
