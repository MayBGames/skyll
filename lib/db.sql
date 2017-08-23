create type NodeType as enum (
  'ground',
  'stairs_up'
);

create type Direction as enum (
  'right',
  'left',
  'up',
  'down'
);

create table grid (
  id serial primary key,
  name text not null unique,
  created timestamp not null default now()
);

create table block (
  id serial primary key,
  grid integer not null references grid (id),
  size point not null,
  properties text[ ],
  direction Direction not null
);

create table node (
  id serial not null primary key,
  block integer not null references block (id),
  kind NodeType not null,
  size point not null,
  location point not null,
  attributes jsonb
);

create table geometry (
  id serial not null primary key,
  node integer not null references node (id),
  left_face integer[ ][ ] not null,
  top_face integer[ ][ ] not null,
  right_face integer[ ][ ] not null,
  bottom_face integer[ ][ ] not null,
  front_face integer[ ][ ] not null,
  back_face integer[ ][ ] not null,
  bezel integer[ ][ ]
);
