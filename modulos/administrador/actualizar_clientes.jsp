<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Actualizar Clientes - EPS Securitas</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <!-- Estilos personalizados -->
    <style>
        /* Estilos para el cuerpo del formulario */
        body {
            background-color: #f8f9fa;
        }
        .container {
            background-color: #ffffff;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            padding: 30px;
            margin-top: 50px;
        }
        /* Estilos para los botones */
        .btn-primary {
            background-color: #007bff;
            border-color: #007bff;
        }
        .btn-primary:hover {
            background-color: #0056b3;
            border-color: #0056b3;
        }
        .btn-secondary {
            background-color: #6c757d;
            border-color: #6c757d;
        }
        .btn-secondary:hover {
            background-color: #5a6268;
            border-color: #545b62;
        }
        /* Estilos para el footer */
        .footer {
            background-color: #343a40;
            color: #ffffff;
            text-align: center;
            position: fixed;
            bottom: 0;
            width: 100%;
            padding: 15px 0;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1 class="mt-5 mb-4">Actualizar Clientes</h1>
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>Documento</th>
                    <th>Nombre</th>
                    <th>Apellido</th>
                    <th>Estado Civil</th>
                    <th>Dirección</th>
                    <th>Correo</th>
                    <th>Actualizar</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    Connection conexion = null;
                    PreparedStatement pstmt = null;
                    ResultSet rs = null;
                    try {
                        Class.forName("com.mysql.jdbc.Driver");
                        conexion = DriverManager.getConnection("jdbc:mysql://localhost/dbeps", "root", "123456");
                        
                        String selectSQL = "SELECT documento, nombre, apellido, estadoCivil, direccion, correo FROM cliente";
                        pstmt = conexion.prepareStatement(selectSQL);
                        rs = pstmt.executeQuery();
                        
                        while (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getString("documento") %></td>
                    <td><%= rs.getString("nombre") %></td>
                    <td><%= rs.getString("apellido") %></td>
                    <td>
                        <form action="" method="post">
                            <input type="hidden" name="documento" value="<%= rs.getString("documento") %>">
                            <select class="form-control" name="estadoCivil" required>
                                <option value="soltero" <%= rs.getString("estadoCivil").equals("soltero") ? "selected" : "" %>>Soltero/a</option>
                                <option value="casado" <%= rs.getString("estadoCivil").equals("casado") ? "selected" : "" %>>Casado/a</option>
                                <option value="divorciado" <%= rs.getString("estadoCivil").equals("divorciado") ? "selected" : "" %>>Divorciado/a</option>
                                <option value="viudo" <%= rs.getString("estadoCivil").equals("viudo") ? "selected" : "" %>>Viudo/a</option>
                            </select>
                    </td>
                    <td><input type="text" class="form-control" name="direccion" value="<%= rs.getString("direccion") %>" required></td>
                    <td><input type="email" class="form-control" name="correo" value="<%= rs.getString("correo") %>" required></td>
                    <td>
                        <button type="submit" class="btn btn-primary">Actualizar</button>
                        </form>
                    </td>
                </tr>
                <% 
                        }
                    } catch (ClassNotFoundException | SQLException e) {
                        e.printStackTrace();
                    } finally {
                        try {
                            if (rs != null) rs.close();
                            if (pstmt != null) pstmt.close();
                            if (conexion != null) conexion.close();
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    }
                %>
            </tbody>
        </table>
        <% 
            if ("POST".equals(request.getMethod())) {
                // Procesar el formulario para actualizar el cliente
                String documento = request.getParameter("documento");
                String estadoCivil = request.getParameter("estadoCivil");
                String direccion = request.getParameter("direccion");
                String correo = request.getParameter("correo");
                
                Connection conexionActualizar = null;
                PreparedStatement pstmtActualizar = null;
                
                try {
                    Class.forName("com.mysql.jdbc.Driver");
                    conexionActualizar = DriverManager.getConnection("jdbc:mysql://localhost/dbeps", "root", "123456");
                    
                    String updateSQL = "UPDATE cliente SET estadoCivil=?, direccion=?, correo=? WHERE documento=?";
                    pstmtActualizar = conexionActualizar.prepareStatement(updateSQL);
                    pstmtActualizar.setString(1, estadoCivil);
                    pstmtActualizar.setString(2, direccion);
                    pstmtActualizar.setString(3, correo);
                    pstmtActualizar.setString(4, documento);
                    
                    int filasActualizadas = pstmtActualizar.executeUpdate();
                    
                    if (filasActualizadas > 0) {
        %>
        <div class="alert alert-success mt-3">Datos actualizados exitosamente</div>
        <%              } else { %>
        <div class="alert alert-danger mt-3">Error al actualizar los datos</div>
        <%              }
                } catch (ClassNotFoundException | SQLException e) {
                    e.printStackTrace();
                } finally {
                    try {
                        if (pstmtActualizar != null) pstmtActualizar.close();
                        if (conexionActualizar != null) conexionActualizar.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            }
        %>
        <button type="button" class="btn btn-secondary" onclick="location.href='principal.jsp';">Volver</button>
       
    </div>


    <!-- Bootstrap JS (opcional, si necesitas funcionalidades de Bootstrap) -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
