var routes;

routes = {
  "index": {
    url: "/",
    controller: "Index",
    view: "index"
  },
  "status": {
    url: "/status/{statusId:[a-zA-Z0-9]{10,20}}",
    views: {
      "": {
        controller: "Index",
        view: "index"
      },
      "info": {
        controller: "StatusInfo",
        view: "status-info"
      }
    }
  },
  "error": {
    url: "/error",
    controller: "Error",
    error: "404",
    view: "404"
  }
};

//# sourceMappingURL=routes.js.map
