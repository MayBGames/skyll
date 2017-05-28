create type Mode as enum (
  'GROUND',
  'WALL',
  'ROOF',
  'OBSTACLE',
  'COLLECTABLE',
  'ENEMY',
  'NPC',
  'SPECIAL',
  'DECORATION'
);

create table piece (
  id serial primary key,
  name text not null unique,
  mode Mode not null,
  properties jsonb
);

insert into piece (name, mode) values ('Ground', 'GROUND');
insert into piece (name, mode) values ('Wall',   'WALL');
insert into piece (name, mode) values ('Roof',   'ROOF');

create table grid (
  id serial primary key,
  name text not null unique,
  created timestamp default now()
);

create table block (
  id serial primary key,
  x integer not null,
  y integer not null,
  index integer not null,
  grid integer not null references grid (id),
  constraint block_coord unique(grid, index, x, y)
);

create table point (
  id serial primary key,
  block integer not null references block (id),
  x integer not null,
  y integer not null,
  volume jsonb not null,
  piece integer not null references piece (id),
  constraint ground_coord unique(block, piece, x, y)
);
