function ShotAccuracy(manual,detect,tolerance)


    correct = 0;
    for i=1:size(detect,1)
        val = detect(i);
        detected = find(abs(manual-val)<=tolerance,1);
        if ~isempty(detected)
            correct = correct + 1;            
            manual(detected(1)) = -1;
        end
    end
    
    recall = correct / size(manual,1);
    precision = correct/size(detect,1);
    F = 2*recall*precision/(recall+precision);
    fprintf("Recall of the detected Shot : %0.4f \n" , recall*100);
    fprintf("Precision of the detected Shot : %0.4f \n" , precision*100);
    fprintf("F1 score = %0.4f \n\n",F);
    miss = manual(manual>=0);
    if size(miss,1) > 0
        fprintf("The undetected shots are : \n");
        disp(miss);
    end

end