use volunteeringpeel;

drop table if exists sponsor;
drop table if exists contact;
drop table if exists request;
drop table if exists faq;
drop table if exists user_shift;
drop table if exists user;
drop table if exists role;
drop table if exists shift;
drop table if exists event;

create table if not exists event (
  event_id    int           not null auto_increment primary key comment 'Unique event ID',
  name        varchar(64)   not null                            comment 'Event name',
  address     varchar(256)  not null                            comment 'Event address (full address)',
  transport   varchar(32)   default null                        comment 'Transport origin location (null if none)',
  description text          not null                            comment 'Event description',
  active      boolean       not null default 0                  comment 'Event visible on events page?'
);

create table if not exists shift (
  shift_id    int           not null auto_increment primary key comment 'Unique shift ID',
  event_id    int           not null                            comment 'Parent event',
  shift_num   int           not null                            comment 'Shift number',
  start_time  datetime      not null                            comment 'Start date + time',
  end_time    datetime      not null                            comment 'End date + time',
  max_spots   int           not null                            comment 'Maximum number of spots',
  meals       set('breakfast', 'lunch', 'dinner', 'snack')      comment 'Provided food',
  notes       text          not null                            comment 'Shift notes',
  foreign key fk_shift_event (event_id) references event(event_id) on update cascade on delete cascade,
  unique key uk_shift (event_id, shift_num)
);

create table if not exists role (
  role_id     int           not null primary key                comment 'Unique role ID',
  name        varchar(16)   not null unique                     comment 'Friendly name'
);

create table if not exists user (
  user_id     int           not null auto_increment primary key comment 'Unique user ID',
  email       varchar(128)  not null unique                     comment 'Email',
  role_id     int           not null default 1                  comment 'Volunteer/organizer/executive',
  first_name  varchar(32)   not null                            comment 'First name',
  last_name   varchar(32)   not null                            comment 'Last name',
  phone_1     varchar(15)                                       comment 'Phone contact #1 (for volunteers/organizers)',
  phone_2     varchar(15)                                       comment 'Phone contact #2 (for volunteers)',
  mail_list   boolean       not null default 0                  comment 'Is user on mailing list?',
  bio         text                                              comment 'For execs, bio for about page',
  foreign key fk_user_role (role_id) references role(role_id)
);

create table if not exists user_shift (
  shift_id    int           not null                            comment 'Shift ID',
  user_id     int           not null                            comment 'User ID',
  foreign key fk_user_shift_shift (shift_id) references shift(shift_id) on update cascade on delete cascade,
  foreign key fk_user_shift_user (user_id) references user(user_id) on update cascade on delete cascade,
  unique key uk_user_shift (user_id, shift_id)
);

create table if not exists faq (
  faq_id      int           not null auto_increment primary key comment 'Unique FAQ id',
  priority    int           not null default 100                comment 'Position on screen',
  question    text          not null,
  answer      text          not null
);

create table if not exists request (
  request_id  int           not null auto_increment primary key comment 'Unique event request ID',
  user_id     int           not null                            comment 'Organizer',
  title       varchar(64)   not null                            comment 'Event name',
  time        varchar(64)   not null                            comment 'Event time',
  location    varchar(256)  not null                            comment 'Event location',
  cause       varchar(64)   not null                            comment 'Event cause/motive',
  max_spots   int           not null                            comment 'Number of volunteers needed',
  jobs        text          not null                            comment 'Volunteer jobs available',
  bring       text          not null                            comment 'What volunteers need to bring',
  transport   text          not null                            comment 'Transportation (if necessary)',
  foreign key fk_request_user (user_id) references user(user_id)
);

create table if not exists contact (
  contact_id  int           not null auto_increment primary key comment 'Unique contact request ID',
  name        varchar(32)   not null                            comment 'Contacter name',
  email       varchar(64)   not null                            comment 'Contacter email',
  exec_id     int           not null                            comment 'Preferred executive (attn)',
  message     text          not null                            comment 'Message',
  foreign key fk_contact_user (exec_id) references user(user_id)
);

create table if not exists sponsor (
  sponsor_id  int           not null auto_increment primary key comment 'Unique sponsor ID',
  name        varchar(64)   not null                            comment 'Display name',
  image       varchar(128)  not null                            comment 'Image link',
  website     varchar(256)  not null                            comment 'Website',
  priority    int           not null default 100                comment 'Priority on page'
);
