-- Задание № 2
-- Пусть заданный пользователь будет с id 1

insert into messages (from_user_id, to_user_id, message) values  
(1, 5, 'вавыаы'),
(1, 5, 'вавыаы'),
(1, 6, 'вавыаы'),
(1, 7, 'вавыаы'),
(1, 5, 'вавыаы'),
(5, 1, 'вавыаы'),
(1, 5, 'вавыаы'),
(7, 1, 'вавыаы'),
(7, 1, 'вавыаы'),
(1, 5, 'вавыаы'),
(5, 1, 'вавыаы');


 
 select friend_id, count(*) as count from (
 select 
  case
    when from_user_id = 1 then to_user_id
    when to_user_id = 1 then from_user_id 
  end as friend_id
  from messages) as abc where friend_id is not null group by friend_id order by count desc limit 1;

 
 -- Задание № 3 У меня нет лайков для пользователей, поэтому сделаю с фотографиями
-- C этим заданием не справился, потому что уже сам не понимаю правильно считается все или нет

select 
(select id from users u where u.id = p.user_id) as photo_owner,
(select birthday from users u where u.id = p.id) as birthday_at,
(select count(*) from photo_likes pl2 where pl2.photo_id = p.id) as likes
from photos p order by birthday_at desc limit 10;




-- Задание № 4

select 
(select 
(select 
(select count(*) from photo_likes where user_id in (select id from users where gender ='m')) +
(select count(*) from comment_likes where user_id in (select id from users where gender ='m')) +
(select count(*) from post_likes where user_id in (select id from users where gender ='m')))) as men,
(select 
((select count(*) from photo_likes where user_id in (select id from users where gender ='f')) +
(select count(*) from comment_likes where user_id in (select id from users where gender ='f')) +
(select count(*) from post_likes where user_id in (select id from users where gender ='f')))) as women,
(select (if(men > women, 'men', 'women'))) as 'The most';

-- Задание № 5
-- Формула активности: Активность = Лайк комментария + Лайк коммента + Лайк фото + 2 * Выложенный пост + 2 * Выложенный коммент

select 
id,
concat(firstname, ' ', lastname) as name,
(select count(*) from photo_likes pl where pl.user_id = u.id group by user_id) as photo_likes,
(select count(*) from post_likes pol where pol.user_id = u.id group by user_id) as post_likes,
(select count(*) from comment_likes cl where cl.user_id = u.id group by user_id) as comment_likes,
(select count(*) from comments c where c.user_id = u.id group by user_id) as comments,
(select count(*) from posts p where p.user_id = u.id group by user_id) as posts,
(select IFNULL(photo_likes, 0) + IFNULL(post_likes, 0)+ IFNULL(comment_likes, 0) + 2 * IFNULL(comments, 0) + 2 * IFNULL(posts, 0))
as activity
from users u order by activity limit 10;
