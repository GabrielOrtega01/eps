<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cerrando Sesión...</title>
</head>
<body>
    <%-- Cierra la sesión --%>
    <% session.invalidate(); %>
    
    <%-- Redirige a la página de inicio de sesión --%>
    <% response.sendRedirect(request.getContextPath() + "/login.jsp"); %>
</body>
</html>
