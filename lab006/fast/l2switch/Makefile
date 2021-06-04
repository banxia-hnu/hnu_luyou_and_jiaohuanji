all:
	gcc -o l2switch main_l2switch.c -I ../include -L../libreg -L../librule -L../libua -lrule -lua -lreg -lpthread
	gcc -o fastio main.c -I ../include -L../libreg -L../librule -L../libua -lrule -lua -lreg -lpthread
clean:
	rm -f *.o l2switch
	rm -f *.o fastio
