<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.SQLException"%>
<%@ page import="java.sql.ResultSet"%>
<%
    // Obtener los parámetros de la solicitud (username y password)
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    boolean credencialesIncorrectas = false; // Variable para controlar si las credenciales son incorrectas

    // Verificar si se han enviado credenciales
    if (username != null && password != null) {
        Connection conexion = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;

        try {
            // Establecer la conexión con la base de datos
            Class.forName("com.mysql.jdbc.Driver");
            conexion = DriverManager.getConnection("jdbc:mysql://localhost/dbeps", "root", "123");

            // Consulta para verificar las credenciales del usuario
            String query = "";

            // Verificar si el usuario es un cliente
            String queryCliente = "SELECT idcliente, nombre, apellido FROM cliente WHERE documento = ? AND clave = ?";
            statement = conexion.prepareStatement(queryCliente);
            statement.setString(1, username);
            statement.setString(2, password);
            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                // Si se encontró el cliente, guardar el idCliente en la sesión
                session.setAttribute("idCliente", resultSet.getInt("idcliente"));
                session.setAttribute("tipoUsuario", "cliente");
                session.setAttribute("nombreUsuario", resultSet.getString("nombre"));
                session.setAttribute("apellidoUsuario", resultSet.getString("apellido"));
                response.sendRedirect("modulos/clientes/principal.jsp");
                return; // Terminar la ejecución del código
            } else {
                // Si no se encontró al cliente, verificar si es un administrador
                String queryAdministrador = "SELECT idadministrador, nombre, apellido FROM administrador WHERE documento = ? AND clave = ?";
                statement = conexion.prepareStatement(queryAdministrador);
                statement.setString(1, username);
                statement.setString(2, password);
                resultSet = statement.executeQuery();

                if (resultSet.next()) {
                    // Si se encontró el administrador, guardar el idAdministrador en la sesión
                    session.setAttribute("idAdministrador", resultSet.getInt("idadministrador"));
                    session.setAttribute("tipoUsuario", "administrador");
                    session.setAttribute("nombreUsuario", resultSet.getString("nombre"));
                    session.setAttribute("apellidoUsuario", resultSet.getString("apellido"));
                    response.sendRedirect("modulos/administrador/principal.jsp");
                    return; // Terminar la ejecución del código
                } else {
                    // Si no se encontró al administrador, verificar si es un médico
                    String queryMedico = "SELECT idmedico, nombre, apellido FROM medico WHERE documento = ? AND clave = ?";
                    statement = conexion.prepareStatement(queryMedico);
                    statement.setString(1, username);
                    statement.setString(2, password);
                    resultSet = statement.executeQuery();

                    if (resultSet.next()) {
                        // Si se encontró el médico, guardar el idMedico en la sesión
                        session.setAttribute("idMedico", resultSet.getInt("idmedico"));
                        session.setAttribute("tipoUsuario", "medico");
                        session.setAttribute("nombreUsuario", resultSet.getString("nombre"));
                        session.setAttribute("apellidoUsuario", resultSet.getString("apellido"));
                        response.sendRedirect("modulos/medico/principal.jsp");
                        return; // Terminar la ejecución del código
                    } else {
                        // Si no se encontró ninguna coincidencia, marcar como credenciales incorrectas
                        credencialesIncorrectas = true;
                    }
                }
            }
        } catch (ClassNotFoundException | SQLException e) {
            // Manejar cualquier excepción que pueda ocurrir durante el proceso de autenticación
            e.printStackTrace();
        } finally {
            // Cerrar conexiones y recursos
            try {
                if (resultSet != null) resultSet.close();
                if (statement != null) statement.close();
                if (conexion != null) conexion.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EPS Curitas</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.6.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
</head>
<body style="display: flex; flex-direction: column; align-items: center; font-family: Arial, sans-serif; background-color: #0E4B77;">
    <img id="logo" src="img/logotipo.png" alt="Logo de la Corporación" style="width: 30%; max-height: 50vh;">
    <div id="login-container" style="text-align: center; max-width: 400px; padding: 20px; border: 1px solid #0C4067; border-radius: 10px; background-color: #3282B5; margin-top: 20px;">
        <h2 style="color: #B5E5FF;">Bienvenido</h2>
        <% if (credencialesIncorrectas) { %>
            <div class="alert alert-danger" role="alert" style="margin-bottom: 10px;">
                Credenciales incorrectas. Por favor, inténtelo de nuevo.
            </div>
        <% } %>
        <form id="login-form" action="login.jsp" method="POST" style="display: flex; flex-direction: column; align-items: center;">

            <label for="username" style="margin-bottom: 5px; color: #D9D9D9;">Documento:</label>
            <input type="text" id="username" name="username" required maxlength="10" placeholder="Documento" style="width: 100%; padding: 8px; margin-bottom: 10px; border: 1px solid #ccc; border-radius: 5px;">
            <label for="password" style="margin-bottom: 5px; color: #D9D9D9;">Clave:</label>
            <input type="password" id="password" name="password" required placeholder="Clave" style="width: 100%; padding: 8px; margin-bottom: 10px; border: 1px solid #ccc; border-radius: 5px;">
            <button type="submit" style="width: 100%; padding: 10px; border: none; border-radius: 5px; background-color: #00C4CC; color: #201e1e; cursor: pointer; transition: background-color 0.3s;">Login</button>
        </form>
        <a href="forgotPassword.jsp" class="forgot-password" style="margin-top: 10px; color: #BBE1F8;">¿Perdiste tu contraseña?</a><br>
        <a href="register.jsp" class="forgot-password" style="margin-top: 10px; color: #BBE1F8;">¿No tienes cuenta? Registrate</a><br>
        <button onclick="location.href='index.html';" style="margin-top: 10px; padding: 10px; border: none; border-radius: 5px; background-color: #00C4CC; color: #201e1e; cursor: pointer; transition: background-color 0.3s;">Volver</button>
    </div>
   <footer class="bg-dark text-light text-center py-3" style="width: 100%; height: 100px;">
        <div class="container">
            <p>&copy; 2024 EPS Securitas. Todos los derechos reservados.</p>
        </div>
    </footer>
</body>
</html>
