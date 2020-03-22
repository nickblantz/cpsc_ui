'use strict';

class RecallList extends React.Component {
  render() {
    const items = [
      {
        id: 0,
        name: "Baby Stroller",
        description: "killed a bunch of kids in gruesome way",
        image_url: "https://images-na.ssl-images-amazon.com/images/I/71SLX6RXyCL._SL1202_.jpg"
      },
      {
        id: 1,
        name: "Electric Toothbrush",
        description: "a lot of people choked on the auto expanding decorative knick-knack",
        image_url: "https://i5.walmartimages.com/asr/8c133656-8eae-449d-81bf-d610cf2d0540_1.8f2e350388f154f77fac07cd9ac0c8c5.jpeg"
      },
      {
        id: 2,
        name: "AR-15",
        description: "pumped up kicks kid got a little excited in band oneday",
        image_url: "https://www.sportsmans.com/medias/ruger-ar556-ar15-semi-auto-rifle-1402156-1.jpg?context=bWFzdGVyfGltYWdlc3wxNDAxMjh8aW1hZ2UvanBlZ3xpbWFnZXMvaGZlL2hlNC84ODkyODkyMjUwMTQyLmpwZ3xkNjgzNTliMGU2YTZkZDllZmEzNTllNDk5ZTc0NzBkYWViZjUxOWUwODVjMWIxMWQxZWQyY2RmOWYyZDAxYTA4"
      },
    ];

    const dom_elems = items.map((item) =>
      React.createElement("div", { className: 'row', key: item.id }, 
        React.createElement("div", { className: 'col-2' }, 
          React.createElement("img", { className: 'img-thumbnail', src: item.image_url }, null)
        ),
        React.createElement("div", { className: 'col-8' }, 
          React.createElement("h3", null, item.name),
          React.createElement("h3", { className: 'lead' }, item.description)
        ),
        React.createElement("div", { className: 'col-2' }, 
          React.createElement("button", { className: 'btn btn-primary' }, "Click Me")
        )
      )
    );

    return React.createElement("div", { className: 'container' }, dom_elems);
  }
}

ReactDOM.render(React.createElement(RecallList), document.getElementById('app_container'));
