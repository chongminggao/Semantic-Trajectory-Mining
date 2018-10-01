function pp = visualizeIntroduction(param,mode)
pp = 0;
if mode == 1
    figure;
    if isfield(param,'img') 
        img = imread(param.img);
        hi = imshow(img);
        
        set(hi,'AlphaData',0.5);
        Xlim = xlim;
        Ylim = ylim;
        Xlim = [0,Xlim(2)+0.5];
        Ylim = [0,Ylim(2)+0.5];
        isRescale = true;
        axis([Xlim,Ylim]);

        if ~isfield(param,'axisRange')
            error('Please specify the axisRange');
        end

    end
    hold on;

    if isRescale    % Scale latLong to the map background image space. 
        minn = param.axisRange([1,3]);
        maxx = param.axisRange([2,4]);
    %     latLong(:,[3,2]) = bsxfun(@rdivide,bsxfun(@minus,latLong(:,[3,2]),minn),maxx-minn);
    %     latLong(:,[3,2]) = bsxfun(@times, latLong(:,[3,2]), [Xlim(2),Ylim(2)]);
    %     latLong(:,2) = Ylim(2) - latLong(:,2);
    %     
    %     latLong_new_representation(:,[3,2]) = bsxfun(@rdivide,bsxfun(@minus,latLong_new_representation(:,[3,2]),minn),maxx-minn);
    %     latLong_new_representation(:,[3,2]) = bsxfun(@times, latLong_new_representation(:,[3,2]), [Xlim(2),Ylim(2)]);
    %     latLong_new_representation(:,2) = Ylim(2) - latLong_new_representation(:,2);
    %     
    end

    color = lines(7);
    blue = color(1,:);
    purple = color(4,:);
    green = color(5,:);


    % #1039517_part
    oneTraj1_ori_a = [41.2292250000000,-8.66805300000000;41.2319520000000,-8.66711700000000;41.2346250000000,-8.66702700000000;41.2376490000000,-8.66799000000000;41.2390440000000,-8.66978100000000;41.2377930000000,-8.67033000000000;41.2371000000000,-8.67020400000000;41.2364700000000,-8.67002400000000;41.2351560000000,-8.66932200000000;41.2364970000000,-8.66913300000000;41.2387290000000,-8.66986200000000;41.2389000000000,-8.67058200000000;41.2377030000000,-8.67027600000000;41.2356150000000,-8.66970000000000;41.2353540000000,-8.66889900000000;41.2375860000000,-8.66945700000000;41.2390800000000,-8.66991600000000;41.2396200000000,-8.67058200000000;41.2380900000000,-8.67055500000000;41.2373160000000,-8.67030300000000;41.2370730000000,-8.67020400000000;41.2370460000000,-8.67006900000000;41.2370370000000,-8.66994300000000;41.2370370000000,-8.66991600000000;41.2366860000000,-8.66984400000000;41.2353540000000,-8.66966400000000;41.2358310000000,-8.66883600000000;41.2376490000000,-8.66948400000000;41.2387830000000,-8.66988900000000;41.2389630000000,-8.66994300000000;41.2386030000000,-8.67050100000000;41.2370460000000,-8.67010500000000;41.2351290000000,-8.66960100000000;41.2345350000000,-8.66967300000000;41.2337700000000,-8.67062700000000;41.2327980000000,-8.67199500000000;41.2315110000000,-8.67385800000000;41.2303680000000,-8.67548700000000;41.2296210000000,-8.67654900000000;41.2286220000000,-8.67798000000000;41.2275150000000,-8.67947400000000;41.2263540000000,-8.68086000000000;41.2259040000000,-8.68136400000000;41.2256880000000,-8.68162500000000;41.2244460000000,-8.68304700000000;41.2230510000000,-8.68465800000000;41.2218000000000,-8.68607100000000;41.2202160000000,-8.68788900000000;41.2187940000000,-8.68942800000000;41.2180830000000,-8.69036400000000;41.2176510000000,-8.68983300000000;41.2173450000000,-8.69108400000000;41.2165080000000,-8.69213700000000;41.2157970000000,-8.69295600000000;41.2148070000000,-8.69383800000000;41.2135560000000,-8.69439600000000;41.2121430000000,-8.69490000000000;41.2106490000000,-8.69553900000000;41.2099380000000,-8.69585400000000;41.2088220000000,-8.69634000000000;41.2072560000000,-8.69632200000000;41.2057350000000,-8.69672700000000;41.2045380000000,-8.69733000000000;41.2033680000000,-8.69737500000000;41.2022340000000,-8.69681700000000;41.2016760000000,-8.69658300000000;41.2014780000000,-8.69665500000000;41.2004430000000,-8.69646600000000;41.1990750000000,-8.69652900000000;41.1973920000000,-8.69662800000000;41.1960510000000,-8.69670900000000;41.1950250000000,-8.69676300000000;41.1943410000000,-8.69679000000000;41.1933780000000,-8.69688900000000;41.1926040000000,-8.69661000000000;41.1921180000000,-8.69625000000000;41.1913350000000,-8.69598900000000;41.1907320000000,-8.69631300000000;41.1896340000000,-8.69534100000000;41.1889050000000,-8.69452200000000;41.1879240000000,-8.69328900000000;41.1870780000000,-8.69229000000000;41.1868980000000,-8.69190300000000;41.1874920000000,-8.69205600000000;41.1879060000000,-8.69240700000000;41.1879420000000,-8.69302800000000;41.1868350000000,-8.69493600000000;41.1858360000000,-8.69630400000000;41.1849810000000,-8.69540400000000;41.1838650000000,-8.69429700000000;41.1828570000000,-8.69334300000000;41.1817320000000,-8.69224500000000;41.1804900000000,-8.69103000000000;41.1794550000000,-8.69033700000000;41.1786990000000,-8.69025600000000;41.1784110000000,-8.69022000000000;41.1771960000000,-8.69006700000000;41.1766200000000,-8.68997700000000;41.1753870000000,-8.68984200000000;41.1741990000000,-8.68938300000000;41.1734430000000,-8.68919400000000;41.1728940000000,-8.68868100000000;41.1721110000000,-8.68795200000000;41.1716070000000,-8.68765500000000;41.1712380000000,-8.68741200000000;41.1698790000000,-8.68712400000000;41.1686460000000,-8.68800600000000;41.1682050000000,-8.68922100000000;41.1672870000000,-8.68851000000000;41.1661800000000,-8.68763700000000;41.1649200000000,-8.68694400000000;41.1643170000000,-8.68659300000000;41.1628140000000,-8.68573800000000;41.1611850000000,-8.68482000000000;41.1597180000000,-8.68399200000000;41.1591780000000,-8.68366800000000;41.1580260000000,-8.68269600000000;41.1571980000000,-8.68198500000000;41.1571980000000,-8.68200300000000;41.1568110000000,-8.68163400000000;41.1558930000000,-8.68086000000000;41.1558660000000,-8.68085100000000;41.1548670000000,-8.68001400000000;41.1534360000000,-8.67892500000000;41.1521670000000,-8.67807900000000;41.1511500000000,-8.67756600000000;41.1504930000000,-8.67669300000000;41.1493590000000,-8.67583800000000;41.1482610000000,-8.67484800000000;41.1477120000000,-8.67330900000000;41.1476400000000,-8.67135600000000;41.1476220000000,-8.66944800000000;41.1475860000000,-8.66799900000000;41.1474690000000,-8.66644200000000;41.1480180000000,-8.66509200000000;41.1479280000000,-8.66335500000000;41.1476220000000,-8.66183400000000;41.1475770000000,-8.66168100000000;41.1475140000000,-8.66140200000000;41.1470190000000,-8.65986300000000;41.1467130000000,-8.65809000000000;41.1473520000000,-8.65655100000000;41.1480810000000,-8.65513800000000;41.1483960000000,-8.65435500000000;41.1483510000000,-8.65351800000000;41.1481980000000,-8.65226700000000;41.1480180000000,-8.65081800000000;41.1479370000000,-8.64927900000000;41.1482250000000,-8.64845100000000;41.1484590000000,-8.64692100000000;41.1483510000000,-8.64552600000000;41.1481440000000,-8.64403200000000;41.1480360000000,-8.64234000000000;41.1484590000000,-8.64024300000000;41.1483600000000,-8.63804700000000;41.1481260000000,-8.63599500000000;41.1475590000000,-8.63406000000000;41.1468120000000,-8.63261100000000;41.1459660000000,-8.63125200000000;41.1448860000000,-8.62936200000000;41.1446610000000,-8.62727400000000;41.1447690000000,-8.62594200000000;41.1444810000000,-8.62427700000000;41.1439410000000,-8.62254000000000;41.1431670000000,-8.62097400000000;41.1420420000000,-8.61956100000000;41.1411420000000,-8.61794100000000;41.1404940000000,-8.61648300000000;41.1407820000000,-8.61527700000000;41.1412410000000,-8.61448500000000;41.1419790000000,-8.61441300000000;41.1423210000000,-8.61427800000000;41.1426090000000,-8.61408900000000;41.1428790000000,-8.61450300000000;41.1428160000000,-8.61519600000000;41.1428250000000,-8.61547500000000;41.1427080000000,-8.61597000000000;41.1426270000000,-8.61652800000000;41.1425100000000,-8.61741900000000;41.1421680000000,-8.61792300000000;41.1424650000000,-8.61879600000000;41.1426270000000,-8.61928200000000;41.1426000000000,-8.61921000000000];
    oneTraj1_ori_a = oneTraj1_ori_a(32:2:123,:);
    % #1054034
    oneTraj1_ori_b = [41.1468210000000,-8.60682600000000;41.1470190000000,-8.60684400000000;41.1471990000000,-8.60755500000000;41.1473160000000,-8.60881500000000;41.1476670000000,-8.61012000000000;41.1478470000000,-8.61048900000000;41.1479010000000,-8.61122700000000;41.1479190000000,-8.61207300000000;41.1475680000000,-8.62182900000000;41.1477660000000,-8.62253100000000;41.1477840000000,-8.62253100000000;41.1480180000000,-8.62357500000000;41.1486840000000,-8.62532100000000;41.1488820000000,-8.62551900000000;41.1492330000000,-8.62559100000000;41.1510240000000,-8.62587000000000;41.1521760000000,-8.62604100000000;41.1521490000000,-8.62603200000000;41.1526350000000,-8.62619400000000;41.1524190000000,-8.62733700000000;41.1524370000000,-8.62849800000000;41.1525630000000,-8.63001900000000;41.1526710000000,-8.63216100000000;41.1511140000000,-8.63516700000000;41.1511950000000,-8.63857800000000;41.1513750000000,-8.64038700000000;41.1513930000000,-8.64060300000000;41.1517620000000,-8.64239400000000;41.1535710000000,-8.64450900000000;41.1565140000000,-8.64577800000000;41.1592230000000,-8.64782100000000;41.1611040000000,-8.64912600000000;41.1629040000000,-8.64892800000000;41.1645240000000,-8.64709200000000;41.1656130000000,-8.64433800000000;41.1669720000000,-8.64203400000000;41.1669360000000,-8.64074700000000;41.1675390000000,-8.64241200000000;41.1686910000000,-8.64387000000000;41.1700950000000,-8.64554400000000;41.1715350000000,-8.64735300000000;41.1735870000000,-8.64990000000000;41.1757650000000,-8.65260000000000;41.1776370000000,-8.65492200000000;41.1799140000000,-8.65771200000000;41.1815520000000,-8.65971900000000;41.1834780000000,-8.66209500000000;41.1854040000000,-8.66445300000000;41.1872760000000,-8.66677500000000;41.1887700000000,-8.66970900000000;41.1894180000000,-8.67375900000000;41.1905430000000,-8.67757500000000;41.1926220000000,-8.68005000000000;41.1951510000000,-8.68263300000000;41.1977610000000,-8.68528800000000;41.2001460000000,-8.68777200000000;41.2026480000000,-8.68983300000000;41.2056090000000,-8.69024700000000;41.2087860000000,-8.69031900000000;41.2124940000000,-8.69040900000000;41.2162920000000,-8.69056200000000;41.2203600000000,-8.69148000000000;41.2243200000000,-8.69352300000000;41.2283970000000,-8.69512500000000;41.2327710000000,-8.69544000000000;41.2370640000000,-8.69593500000000;41.2412220000000,-8.69473800000000;41.2453170000000,-8.69433300000000];
    oneTraj1_ori_b = oneTraj1_ori_b(16:end,:);
    % #855
%     oneTraj1_ori_c = [41.1490170000000,-8.59927500000000;41.1489720000000,-8.59914000000000;41.1491070000000,-8.59885200000000;41.1499080000000,-8.59831200000000;41.1514740000000,-8.59743900000000;41.1530760000000,-8.59643100000000;41.1544350000000,-8.59571100000000;41.1545250000000,-8.59568400000000;41.1544980000000,-8.59560300000000;41.1554070000000,-8.59514400000000;41.1569460000000,-8.59419900000000;41.1584310000000,-8.59329000000000;41.1597360000000,-8.59262400000000;41.1612300000000,-8.59170600000000;41.1626880000000,-8.59055400000000;41.1634620000000,-8.58993300000000;41.1636150000000,-8.58980700000000;41.1636060000000,-8.58981600000000;41.1637140000000,-8.58969900000000;41.1646410000000,-8.58910500000000;41.1663960000000,-8.58841200000000;41.1677010000000,-8.58785400000000;41.1678180000000,-8.58781800000000;41.1678180000000,-8.58782700000000;41.1682680000000,-8.58760200000000;41.1687270000000,-8.58878100000000;41.1692850000000,-8.59063500000000;41.1710220000000,-8.59328100000000;41.1734430000000,-8.59455000000000;41.1764220000000,-8.59335300000000;41.1799410000000,-8.59294800000000;41.1835770000000,-8.59332600000000;41.1871140000000,-8.59452300000000;41.1905250000000,-8.59370400000000;41.1936480000000,-8.59143600000000;41.1967440000000,-8.58868200000000;41.2000110000000,-8.58632400000000;41.2032330000000,-8.58357000000000;41.2071480000000,-8.58231900000000;41.2106040000000,-8.57971800000000;41.2139610000000,-8.57667600000000;41.2178220000000,-8.57508300000000;41.2218090000000,-8.57392200000000;41.2255890000000,-8.57200500000000;41.2293060000000,-8.57004300000000;41.2324560000000,-8.56698300000000;41.2357410000000,-8.56474200000000;41.2381440000000,-8.56234800000000;41.2402320000000,-8.56075500000000;41.2404840000000,-8.55748800000000;41.2399170000000,-8.55371700000000;41.2392600000000,-8.54977500000000;41.2437870000000,-8.54924400000000;41.2444980000000,-8.55035100000000;41.2448850000000,-8.55110700000000;41.2456860000000,-8.55139500000000];
    oneTraj1_ori_c = [41.2396920000000,-8.55126000000000;41.2403850000000,-8.55550800000000;41.2410510000000,-8.55918000000000;41.2419330000000,-8.56109700000000;41.2400070000000,-8.56150200000000;41.2377840000000,-8.56276200000000;41.2374780000000,-8.56540800000000;41.2356600000000,-8.56543500000000;41.2332390000000,-8.56673100000000;41.2306200000000,-8.56919700000000;41.2275240000000,-8.57162700000000;41.2243200000000,-8.57274300000000;41.2213680000000,-8.57452500000000;41.2177410000000,-8.57548800000000;41.2140330000000,-8.57691000000000;41.2108560000000,-8.57983500000000;41.2075620000000,-8.58249000000000;41.2037280000000,-8.58376800000000;41.2005060000000,-8.58609900000000;41.1974460000000,-8.58854700000000;41.1947820000000,-8.59064400000000;41.1935310000000,-8.59171500000000;41.1933780000000,-8.59179600000000;41.1931710000000,-8.59188600000000;41.1918840000000,-8.59253400000000;41.1914430000000,-8.59292100000000;41.1905520000000,-8.59382100000000;41.1896250000000,-8.59449600000000;41.1886890000000,-8.59482000000000;41.1877260000000,-8.59484700000000;41.1869970000000,-8.59466700000000;41.1857010000000,-8.59425300000000;41.1836400000000,-8.59357800000000;41.1806880000000,-8.59307400000000;41.1774030000000,-8.59342500000000;41.1745500000000,-8.59428000000000;41.1720480000000,-8.59610700000000;41.1715440000000,-8.59864500000000;41.1713910000000,-8.60120100000000;41.1721110000000,-8.60361300000000;41.1723990000000,-8.60492700000000;41.1711750000000,-8.60481000000000;41.1699870000000,-8.60576400000000;41.1694740000000,-8.60616900000000;41.1693570000000,-8.60625900000000;41.1688890000000,-8.60652000000000;41.1685830000000,-8.60654700000000;41.1681510000000,-8.60656500000000;41.1681330000000,-8.60655600000000;41.1677280000000,-8.60655600000000;41.1668010000000,-8.60658300000000;41.1665040000000,-8.60745600000000;41.1656940000000,-8.60760000000000;41.1656760000000,-8.60789700000000;41.1655320000000,-8.60841000000000;41.1654690000000,-8.60847300000000;41.1654420000000,-8.60850000000000;41.1648120000000,-8.60850000000000;41.1648030000000,-8.60847300000000;41.1648120000000,-8.60847300000000;41.1644610000000,-8.60849100000000;41.1630930000000,-8.60885100000000;41.1622200000000,-8.60919300000000;41.1611040000000,-8.60967900000000;41.1601680000000,-8.60991300000000;41.1590610000000,-8.60995800000000;41.1579000000000,-8.60997600000000;41.1577110000000,-8.60996700000000;41.1566490000000,-8.61003000000000;41.1549300000000,-8.61001200000000;41.1532110000000,-8.60991300000000;41.1513840000000,-8.61049800000000;41.1504750000000,-8.61084000000000;41.1504210000000,-8.61086700000000;41.1493320000000,-8.61118200000000;41.1486390000000,-8.61197400000000;41.1481620000000,-8.61296400000000;41.1482160000000,-8.61323400000000;41.1482070000000,-8.61326100000000];

    oneTraj1_a(:,[2,1]) = bsxfun(@rdivide,bsxfun(@minus,oneTraj1_ori_a(:,[2,1]),minn),maxx-minn);
    oneTraj1_a(:,[2,1]) = bsxfun(@times, oneTraj1_a(:,[2,1]), [Xlim(2),Ylim(2)]);
    oneTraj1_a(:,1) = Ylim(2) - oneTraj1_a(:,1);

    oneTraj1_b(:,[2,1]) = bsxfun(@rdivide,bsxfun(@minus,oneTraj1_ori_b(:,[2,1]),minn),maxx-minn);
    oneTraj1_b(:,[2,1]) = bsxfun(@times, oneTraj1_b(:,[2,1]), [Xlim(2),Ylim(2)]);
    oneTraj1_b(:,1) = Ylim(2) - oneTraj1_b(:,1);

    oneTraj1_c(:,[2,1]) = bsxfun(@rdivide,bsxfun(@minus,oneTraj1_ori_c(:,[2,1]),minn),maxx-minn);
    oneTraj1_c(:,[2,1]) = bsxfun(@times, oneTraj1_c(:,[2,1]), [Xlim(2),Ylim(2)]);
    oneTraj1_c(:,1) = Ylim(2) - oneTraj1_c(:,1);


    h1 = plot(oneTraj1_a(:,2),oneTraj1_a(:,1),'o-','LineWidth',1.5,'Color',blue,'MarkerSize',10);
    h2 = plot(oneTraj1_b(:,2),oneTraj1_b(:,1),'o-','LineWidth',1.5,'Color',purple,'MarkerSize',10);
    h3 = plot(oneTraj1_c(:,2),oneTraj1_c(:,1),'o-','LineWidth',1.5,'Color',green,'MarkerSize',10);

    a = text(200,100,'$T_3$','Interpreter','latex','FontSize',60);
    a = text(200,100,'$T_2$','Interpreter','latex','FontSize',60);
    a = text(200,100,'$T_1$','Interpreter','latex','FontSize',60);
else
    figure;
%     hold on;
    if isfield(param,'imgNetwork') 
        img = imread(param.imgNetwork);
        hi = imshow(img);
        set(hi,'AlphaData',0.3);
        Xlim = xlim;
        Ylim = ylim;
        Xlim = [0,Xlim(2)+0.5];
        Ylim = [0,Ylim(2)+0.5];
        isRescale = true;
        axis([Xlim,Ylim]);

        if ~isfield(param,'axisRange')
            error('Please specify the axisRange');
        end

    end
    hold on;
%      pp = patch([0 Xlim(2) Xlim(2) 0],[0 0 Ylim(2) Ylim(2)],[1 1 1]);
%      pp.FaceAlpha = 0.7;
%      pp.LineStyle = 'none';

    if isRescale    % Scale latLong to the map background image space. 
        minn = param.axisRange([1,3]);
        maxx = param.axisRange([2,4]);
    %     latLong(:,[3,2]) = bsxfun(@rdivide,bsxfun(@minus,latLong(:,[3,2]),minn),maxx-minn);
    %     latLong(:,[3,2]) = bsxfun(@times, latLong(:,[3,2]), [Xlim(2),Ylim(2)]);
    %     latLong(:,2) = Ylim(2) - latLong(:,2);
    %     
    %     latLong_new_representation(:,[3,2]) = bsxfun(@rdivide,bsxfun(@minus,latLong_new_representation(:,[3,2]),minn),maxx-minn);
    %     latLong_new_representation(:,[3,2]) = bsxfun(@times, latLong_new_representation(:,[3,2]), [Xlim(2),Ylim(2)]);
    %     latLong_new_representation(:,2) = Ylim(2) - latLong_new_representation(:,2);
    %     
    end

    color = lines(7);
    blue = color(1,:);
    purple = color(4,:);
    green = color(5,:);


    % #1039517_part
    oneTraj1_ori_a = [41.2283078125000,-8.66892822265625;41.2362351562500,-8.66907832031250;41.2283078125000,-8.68123623046875;41.2192945312500,-8.68934150390625;41.2083265625000,-8.69069238281250;41.2052859375000,-8.69714658203125;41.2038742187500,-8.68949160156250;41.1874765625000,-8.69564560546875;41.1805265625000,-8.69144287109375;41.1643460937500,-8.68513876953125;41.1582648437500,-8.68153642578125;41.1533781250000,-8.66787753906250;41.1476226562500,-8.65752080078125;41.1532695312500,-8.63905878906250;41.1517492187500,-8.63140380859375;41.1416500000000,-8.63740771484375;41.1430617187500,-8.61669423828125];
    oneTraj1_ori_a = oneTraj1_ori_a(2:end - 6,:);
    oneTraj1_ori_a(6,:) = [];
    % #1054034
    oneTraj1_ori_b = [41.1477312500000,-8.60768837890625;41.1477312500000,-8.61564355468750;41.1517492187500,-8.63140380859375;41.1532695312500,-8.63905878906250;41.1535953125000,-8.65136679687500;41.1608710937500,-8.65241748046875;41.1623914062500,-8.63815820312500;41.1722734375000,-8.64971572265625;41.1800921875000,-8.65316796875000;41.1850875000000,-8.66382490234375;41.1914945312500,-8.67913486328125;41.1998562500000,-8.68784052734375;41.2038742187500,-8.68949160156250;41.2083265625000,-8.69069238281250;41.2192945312500,-8.68934150390625;41.2222265625000,-8.69579570312500;41.2277648437500,-8.69504521484375;41.2363437500000,-8.69669628906250;41.2425335937500,-8.70029863281250];
    oneTraj1_ori_b = oneTraj1_ori_b(3:end,:);
    % #855
%     oneTraj1_ori_c = [41.1525093750000,-8.59447978515625;41.1560929687500,-8.59583066406250;41.1607625000000,-8.59973320312500;41.1654320312500,-8.58757529296875;41.1705359375000,-8.59327900390625;41.1729250000000,-8.58757529296875;41.1786804687500,-8.60018349609375;41.1866078125000,-8.59553046875000;41.1944265625000,-8.59267861328125;41.1986617187500,-8.59042714843750;41.2006164062500,-8.58382285156250;41.2087609375000,-8.58217177734375;41.2142992187500,-8.57856943359375;41.2246156250000,-8.57301582031250;41.2317828125000,-8.56941347656250;41.2365609375000,-8.56581113281250;41.2409046875000,-8.56461035156250];
    oneTraj1_ori_c = [41.2409046875000,-8.56461035156250;41.2365609375000,-8.56581113281250;41.2317828125000,-8.56941347656250;41.2246156250000,-8.57301582031250;41.2142992187500,-8.57856943359375;41.2087609375000,-8.58217177734375;41.2006164062500,-8.58382285156250;41.1986617187500,-8.59042714843750;41.1944265625000,-8.59267861328125;41.1866078125000,-8.59553046875000;41.1786804687500,-8.60018349609375;41.1729250000000,-8.58757529296875;41.1705359375000,-8.59327900390625;41.1727078125000,-8.60288525390625;41.1761828125000,-8.60828876953125;41.1727078125000,-8.60288525390625;41.1674953125000,-8.60468642578125;41.1639117187500,-8.61084042968750;41.1537039062500,-8.61219130859375;41.1477312500000,-8.61564355468750];
    oneTraj1_ori_c(15,:) = [];

    oneTraj1_a(:,[2,1]) = bsxfun(@rdivide,bsxfun(@minus,oneTraj1_ori_a(:,[2,1]),minn),maxx-minn);
    oneTraj1_a(:,[2,1]) = bsxfun(@times, oneTraj1_a(:,[2,1]), [Xlim(2),Ylim(2)]);
    oneTraj1_a(:,1) = Ylim(2) - oneTraj1_a(:,1);

    oneTraj1_b(:,[2,1]) = bsxfun(@rdivide,bsxfun(@minus,oneTraj1_ori_b(:,[2,1]),minn),maxx-minn);
    oneTraj1_b(:,[2,1]) = bsxfun(@times, oneTraj1_b(:,[2,1]), [Xlim(2),Ylim(2)]);
    oneTraj1_b(:,1) = Ylim(2) - oneTraj1_b(:,1);

    oneTraj1_c(:,[2,1]) = bsxfun(@rdivide,bsxfun(@minus,oneTraj1_ori_c(:,[2,1]),minn),maxx-minn);
    oneTraj1_c(:,[2,1]) = bsxfun(@times, oneTraj1_c(:,[2,1]), [Xlim(2),Ylim(2)]);
    oneTraj1_c(:,1) = Ylim(2) - oneTraj1_c(:,1);

    oneTraj1_a = oneTraj1_a - 2;
    oneTraj1_b = oneTraj1_b - 2;
    oneTraj1_c = oneTraj1_c - 2;
    
    
    h1 = plot(oneTraj1_a(:,2),oneTraj1_a(:,1),'p-','LineWidth',3,'Color',blue,'MarkerSize',24);
    h2 = plot(oneTraj1_b(:,2),oneTraj1_b(:,1),'p-','LineWidth',3,'Color',purple,'MarkerSize',24);
    h3 = plot(oneTraj1_c(:,2),oneTraj1_c(:,1),'p-','LineWidth',3,'Color',green,'MarkerSize',24);

    a = text(200,100,'$T_3$','Interpreter','latex','FontSize',60);
    a = text(200,100,'$T_2$','Interpreter','latex','FontSize',60);
    a = text(200,100,'$T_1$','Interpreter','latex','FontSize',60);
end


a = 1;


end